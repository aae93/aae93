import os
import tarfile
import difflib
import sys
from pathlib import Path

# ANSI цвета
RED = "\033[91m"
GREEN = "\033[92m"
RESET = "\033[0m"

def extract_tar_gz(archive_path, extract_to):
    if os.path.exists(extract_to) and os.listdir(extract_to):
        print(f"📁 Папка {extract_to} уже существует и не пуста — распаковка пропущена")
        return
    with tarfile.open(archive_path, "r:gz") as tar:
        tar.extractall(path=extract_to)
        print(f"📦 Архив распакован в: {extract_to}")

def filter_lines(lines):
    return [line for line in lines if not line.strip().startswith(("#", ";"))]

def compare_files(file1, file2):
    with open(file1, 'r', encoding='utf-8', errors='ignore') as f1, open(file2, 'r', encoding='utf-8', errors='ignore') as f2:
        lines1 = filter_lines(f1.readlines())
        lines2 = filter_lines(f2.readlines())
        diff = list(difflib.unified_diff(lines1, lines2, fromfile='архив', tofile='текущий', lineterm=''))
        return [line for line in diff if line.startswith('+') or line.startswith('-')]

def is_readme_file(filename):
    lower = filename.lower()
    return lower == "readme" or lower == "readme.md"

def compare_directories(archive_dir, current_dir, report_file):
    with open(report_file, 'w', encoding='utf-8') as report:
        for root, _, files in os.walk(archive_dir):
            for file in files:
                if is_readme_file(file):
                    continue  # Пропуск README файлов

                archive_file_path = os.path.join(root, file)
                relative_path = os.path.relpath(archive_file_path, archive_dir)
                current_file_path = os.path.join(current_dir, relative_path)

                if os.path.exists(current_file_path):
                    diff = compare_files(archive_file_path, current_file_path)
                    if diff:
                        print(f"\n📄 {relative_path}")
                        report.write(f"\n📄 {relative_path}\n")
                        for line in diff:
                            if line.startswith('+'):
                                print(f"{RED}{line}{RESET}")   # Архив — красный
                                report.write(line + '\n')
                            elif line.startswith('-'):
                                print(f"{GREEN}{line}{RESET}") # Текущий — зелёный
                                report.write(line + '\n')
                else:
                    msg = f"\n📄 {relative_path} (файл отсутствует в текущем каталоге)"
                    print(msg)
                    report.write(msg + '\n')

def main():
    if len(sys.argv) != 2:
        print("❗ Использование: python compare_configs.py <архив.tar.gz>")
        sys.exit(1)

    archive_path = sys.argv[1]
    if not os.path.isfile(archive_path):
        print(f"❗ Архив не найден: {archive_path}")
        sys.exit(1)

    current_dir = os.getcwd()
    temp_dir = os.path.join(current_dir, "example_config")

    os.makedirs(temp_dir, exist_ok=True)
    report_path = os.path.join(temp_dir, "diff_report.txt")

    extract_tar_gz(archive_path, temp_dir)
    compare_directories(temp_dir, current_dir, report_path)

    print(f"\n📝 Отчет сохранён: {report_path}")

if __name__ == "__main__":
    main()
