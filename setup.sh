#!/bin/bash

# Клонирование репозитория
git clone https://github.com/fromkms/chatgpt_telegram_bot.git

# Проверка наличия установленного Git
if ! command -v git &> /dev/null
then
    echo "Git не установлен. Пожалуйста, установите его с помощью команды 'apt install git'."
    exit 1
fi

# Переход в директорию с клонированным репозиторием
cd chatgpt_telegram_bot

# Переименование файлов конфигурации
mv config/config.example.yml config/config.yml
mv config/config.example.env config/config.env

# Запрос API-токена Telegram
while true; do
    printf "Введите ваш API-токен Telegram: "
    read telegram_token

    if [[ -n "$telegram_token" ]]; then
        break
    else
        printf "API-токен Telegram не может быть пустым. Пожалуйста, повторите ввод.\n"
    fi
done

# Запрос ключа API OpenAI
while true; do
    printf "Введите ваш ключ API OpenAI: "
    read openai_api_key

    if [[ -n "$openai_api_key" ]]; then
        break
    else
        printf "Ключ API OpenAI не может быть пустым. Пожалуйста, повторите ввод.\n"
    fi
done

# Запрос разрешенных имен пользователей Telegram
printf "Введите список разрешенных имен пользователей Telegram через запятую (оставьте пустым для разрешения любого): "
read allowed_usernames

# Обновление файла config.yml с введенными значениями
sed -i "s/telegram_token: \"\"/telegram_token: \"$telegram_token\"/g" config/config.yml
sed -i "s/openai_api_key: \"\"/openai_api_key: \"$openai_api_key\"/g" config/config.yml
sed -i "s/allowed_telegram_usernames: \[\]/allowed_telegram_usernames: [$allowed_usernames]/g" config/config.yml

# Запрос тайм-аута нового диалога
printf "Введите время тайм-аута нового диалога в секундах (по умолчанию: 600): "
read new_dialog_timeout

# Обновление файла config.yml с новым тайм-аутом диалога
sed -i "s/new_dialog_timeout: 600/new_dialog_timeout: $new_dialog_timeout/g" config/config.yml

# Переводим на Русский язык!
read -p "Хотите перевести на русский? (по умолчанию Y) (Y/n): " answer

if [[ $answer == "Y" || $answer == "y" ]]; then
   

file_path="bot/bot.py"

# Проверяем, существует ли файл по указанному пути
if [ ! -f "$file_path" ]; then
    file_path="chatgpt_telegram_bot/bot/bot.py"
fi
# Переводим текст на русский и выполняем замены в файле с помощью awk
sed -i '
s/HELP_MESSAGE = \"\"\"Commands:/HELP_MESSAGE = \"\"\"Команды:/g;
s/🎨 Generate images from text prompts in <b>👩‍🎨 Artist<\/b> \/mode/🎨 Создавайте изображения по текстовым подсказкам в режиме <b>👩‍🎨 Художник<\/b> \/режим/g;
s/👥 Add bot to <b>group chat<\/b>: \/help_group_chat/👥 Добавьте бота в <b>групповой чат<\/b>: \/помощь_групповой_чат/g;
s/🎤 You can send <b>Voice Messages<\/b> instead of text/🎤 Вы можете отправлять <b>голосовые сообщения<\/b> вместо текста/g;
s/text = \"⏳ Please <b>wait<\/b> for a reply to the previous message\\n\"/text = \"⏳ Пожалуйста, <b>подождите<\/b>, пока не получите ответ на предыдущее сообщение\\n\"/g;
s/text += \"Or you can \/cancel it\"/text += \"Или вы можете \/отменить его\"/g;
s/text = \"✍️ <i>Note:<\/i> Your current dialog is too long, so your <b>first message<\/b> was removed from the context.\\n Send \/new command to start new dialog\"/text = \"✍️ <i>Примечание:<\/i> Ваш текущий диалог слишком длинный, поэтому ваше <b>первое сообщение<\/b> было удалено из контекста.\\n Отправьте команду \/new, чтобы начать новый диалог\"/g;
s/text = f\"✍️ <i>Note:<\/i> Your current dialog is too long, so <b>{n_first_dialog_messages_removed} first messages<\/b> were removed from the context.\\n Send \/new command to start new dialog\"/text = f\"✍️ <i>Примечание:<\/i> Ваш текущий диалог слишком длинный, поэтому <b>{n_first_dialog_messages_removed} первых сообщений<\/b> были удалены из контекста.\\n Отправьте команду \/new, чтобы начать новый диалог\"/g;
s/if str(e).startswith(\"Your request was rejected as a result of our safety system\")/if str(e).startswith(\"Ваш запрос был отклонен в результате работы нашей системы безопасности\")/g;
s/await update.message.reply_text(\"Starting new dialog ✅\")/await update.message.reply_text(\"Начало нового диалога ✅\")/g;
s/await update.message.reply_text(\"<i>Nothing to cancel...<\/i>\", parse_mode=ParseMode.HTML)/await update.message.reply_text(\"<i>Нет ничего для отмены...<\/i>\", parse_mode=ParseMode.HTML)/g;
s/text = f\"Select <b>chat mode<\/b> ({len(config.chat_modes)} modes available):\"/text = f\"Выберите <b>режим чата<\/b> ({len(config.chat_modes)} доступных режимов):\"/g;
s/if str(e).startswith(\"Message is not modified\")/if str(e).startswith(\"Сообщение не изменено\")/g;
s/details_text = \"🏷 Details:\\n\"/details_text = \"🏷 Детали:\\n\"/g;
s/text = f\"You spent <b>{total_n_spent_dollars:.03f}\\$<\/b>\\n\"/text = f\"Вы потратили <b>{total_n_spent_dollars:.03f}\\$<\/b>\\n\"/g;
s/text += f\"You used <b>{total_n_used_tokens}<\/b> tokens\\n\\n\"/text += f\"Вы использовали <b>{total_n_used_tokens}<\/b> токенов\\n\\n\"/g;
s/text = \"🥲 Unfortunately, message <b>editing<\/b> is not supported\"/text = \"🥲 К сожалению, <b>редактирование<\/b> сообщений не поддерживается\"/g;
s/logger.error(msg=\"Exception while handling an update:\", exc_info=context.error)/logger.error(msg=\"Ошибка при обработке обновления:\", exc_info=context.error)/g;
s/await update.message.reply_text(\"✅ Canceled\", parse_mode=ParseMode.HTML)/await update.message.reply_text(\"✅ Отменено\", parse_mode=ParseMode.HTML)/g;
s/error_text = f\"Something went wrong during completion. Reason: {e}\"/error_text = f\"Что-то пошло не так во время завершения. Причина: {e}\"/g;
s/await update.message.reply_text(f\"Starting new dialog due to timeout (<b>{config.chat_modes[chat_mode][\"name\"]}<\/b> mode) ✅\", parse_mode=ParseMode.HTML)/await update.message.reply_text(f\"Начало нового диалога из-за таймаута (<b>{config.chat_modes[chat_mode][\"name\"]}<\/b> режим) ✅\", parse_mode=ParseMode.HTML)/g;
s/db.set_user_attribute(user_id, \"last_interaction\", datetime.now())/db.set_user_attribute(user_id, \"last_interaction\", datetime.now())/g;
' "$file_path"




# Выводим сообщение о завершении выполнения скрипта
echo "Завершен перевод по строкам."
echo "Переходим к замене файла с режимом чата."

file_path_modes="chatgpt_tg_bot_ru/config/chat_modes.yml"

# Проверка наличия файла по указанному пути
if [ -f "$file_path_modes" ]; then
    echo "Файл chat_modes.yml найден по указанному пути."
else
    echo "Файл chat_modes.yml не найден по указанному пути."
    echo "Выполняется автоматический поиск файла..."

    # Поиск файла в текущей директории и поддиректориях
    file_path_modes=$(find . -name "chat_modes.yml" -print -quit)

    if [ -z "$file_path_modes" ]; then
        echo "Файл chat_modes.yml не найден."
        exit 1
    fi

    echo "Файл найден: $file_path_modes"
fi

# Проверка установки curl
if ! command -v curl &> /dev/null; then
    echo "Установка curl..."

    # Установка curl в фоновом режиме
    apt-get install -y curl > /dev/null &

    # Ожидание завершения установки
    wait $!

    echo "Установка curl завершена."
fi

# Загрузка содержимого файла
curl -sSf "https://raw.githubusercontent.com/persoun/chatgpt_tg_bot_ru/main/config/chat_modes.yml" > temp_file

# Проверка успешности загрузки
if [ $? -eq 0 ]; then
    # Замена содержимого файла
    mv temp_file "$file_path_modes"
    echo "Файл успешно обновлен."
else
    echo "Ошибка при загрузке файла."
fi

# Удаление временного файла
rm temp_file





    
else
    echo "Очень жаль. А мы старались!"
fi


# Сборка и запуск бота с использованием Docker
docker-compose --env-file config/config.env up --build -d