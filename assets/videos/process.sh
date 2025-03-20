#!/bin/bash

# 定义源目录和目标目录
src_dirs=("video1" "video2")
target_dir_suffix="_resized"  # 处理后视频存放的目录后缀

for src_dir in "${src_dirs[@]}"; do
  # 创建目标目录（如果不存在）
  target_dir="${src_dir}${target_dir_suffix}"
  mkdir -p "$target_dir"

  # 遍历源目录中的 MP4 文件
  for file in "$src_dir"/*.mp4; do
    # 提取文件名（不包含路径）
    filename=$(basename "$file")
    
    # 输出处理信息
    echo "正在处理: $file → $target_dir/$filename"

    # 使用 ffmpeg 转换分辨率
    ffmpeg -i "$file" \
      -vf "scale=688:384:force_original_aspect_ratio=decrease,pad=688:384:(ow-iw)/2:(oh-ih)/2" \
      -c:v libx264 -preset fast \
      -c:a copy \
      "$target_dir/$filename"
  done
done

echo "全部视频已转换完成！"




for dir in video1_resized video2_resized; do
  for file in "$dir"/*.mp4; do
    echo "文件: $file"
    ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file"
  done
done