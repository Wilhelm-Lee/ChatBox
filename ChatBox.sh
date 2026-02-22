#!/bin/bash

# 1. Read all input into an array
mapfile -t lines < <(cat /dev/stdin)

num_lines=${#lines[@]}
[[ $num_lines -eq 0 ]] && exit 0 # Exit if no input

# 2. Find the longest line length
max_len=0
for s in "${lines[@]}"; do
    ((${#s} > max_len)) && max_len=${#s}
done

# 3. Pre-generate the horizontal bar
bar=$(printf '─%.0s' $(seq 1 "$max_len"))

# 4. Define the components
face_top="  ╭╭╭  "
face_mid="  ╸╭╺  "
face_bot="  ╰─╯  "
indent="       "

# 5. Render the box
# The Top Border: Only uses face_top if there's exactly one line of text
if [ "$num_lines" -eq 1 ]; then
    printf "%s╭─%s─╮\n" "$face_top" "$bar"
else
    printf "%s╭─%s─╮\n" "$indent" "$bar"
fi

# The Content: Loop through the lines
for i in "${!lines[@]}"; do
    prefix="$indent"
    
    # Logic to attach the face to the bottom-most lines
    if [ "$num_lines" -eq 1 ]; then
        prefix="$face_mid"
    elif [ "$i" -eq "$((num_lines - 2))" ]; then
        prefix="$face_top"
    elif [ "$i" -eq "$((num_lines - 1))" ]; then
        prefix="$face_mid"
    fi

    # %-${max_len}s automatically pads the string with spaces to the right
    printf "%s│ %-${max_len}s │\n" "$prefix" "${lines[$i]}"
done

# The Bottom Border
printf "%s╯─%s─╯\n" "$face_bot" "$bar"




# The first edition, a true legacy:
# #!/bin/bash

# longest_line_length=0
# line_count=0
# buffer=()
# while IFS= read line; do
#     buffer+=("$line")
#     line_count=$((line_count + 1))
#     if [ ${#line} -gt $longest_line_length ]; then
# 	longest_line_length=${#line}
#     fi
# done

# bar="$(PrintFor $longest_line_length '─')"
# indent="$(PrintFor 7 ' ')"

# extra_height=$((line_count - 2))
# # Requires rendering extra vertical buffer lines.
# if [ $extra_height -ge 0 ]; then
#     echo "$indent╭─$bar─╮ "
#     extra_height_countdown=$extra_height
#     while [ $extra_height_countdown -gt 0 ]; do
# 	gap="$(PrintFor $((longest_line_length - ${#buffer[$((line_count - extra_height_countdown - 2))]} + 1)) ' ')"
# 	echo -e "$indent│ ${buffer[$((line_count - extra_height_countdown - 2))]}$gap│ "

# 	extra_height_countdown=$((extra_height_countdown - 1))
#     done

#     gap="$(PrintFor $((longest_line_length - ${#buffer[$((line_count - 2))]} + 1)) ' ')"
#     echo "  ╭╭╭  │ ${buffer[$((line_count - 2))]}$gap│ "
#     gap="$(PrintFor $((longest_line_length - ${#buffer[$((line_count - 1))]} + 1)) ' ')"
#     echo "  ╸╭╺  │ ${buffer[$((line_count - 1))]}$gap│ "
# else
#     echo "  ╭╭╭  ╭─$bar─╮ "
#     echo "  ╸╭╺  │ $buffer │ "
# fi
# echo -e "  ╰─╯  ╯─$bar─╯ "



# # Sample
# #echo -e "  ╭╭╭  ╭─$bar─╮ "
# #echo -e "  ╸╭╺  │ $message │ "
# #echo -e "  ╰─╯  ╯─$bar─╯ "

