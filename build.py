
'''
import subprocess

cmd = """
source ./common_preamble.sh
source ./scripts/1.sh
source ./scripts/2.sh
"""

subprocess.run(cmd, shell=True)
'''


#!/usr/bin/env python3
import argparse
import subprocess
import os
import sys
from pathlib import Path

ROOT = Path(__file__).parent
SCRIPTS_DIR = ROOT / "scripts"
FUZZ_BIN_DIR = ROOT / "fuzzer_bin"
COV_BIN_DIR = ROOT / "coverage_bin"


def run_script(script_path: Path, env=None):
	if not script_path.exists():
		print(f"[!] Build script not found: {script_path}")
		sys.exit(1)

	print(f"[+] Running build script: {script_path}")
	result = subprocess.run(
		["bash", str(script_path)],
		env=env,
		stdout=subprocess.PIPE,
		stderr=subprocess.PIPE,
		text=True
	)

	print(result.stdout)
	if result.returncode != 0:
		print(result.stderr)
		print("[!] Build failed.")
		sys.exit(result.returncode)

	print("[+] Build completed successfully.")


def main():
	parser = argparse.ArgumentParser(description="AutoFuzz build system")
	parser.add_argument(
		"--mode",
		required=True,
		choices=["fuzz", "coverage"],
		help="Build fuzzing binaries or coverage binaries"
	)

	parser.add_argument(
		"--target",
		default=None,
		help="Optional: specify a target name (passed to scripts)"
	)

	args = parser.parse_args()

	# Ensure directories exist
	FUZZ_BIN_DIR.mkdir(exist_ok=True)
	COV_BIN_DIR.mkdir(exist_ok=True)

	# Env vars passed to build scripts
	env = os.environ.copy()
	target = None
	if args.target:
		target = args.target
		env["TARGET"] = args.target

	if args.mode == "fuzz":
		# build_script = SCRIPTS_DIR / "fuzz"
		# env["OUT_DIR"] = str(FUZZ_BIN_DIR)
		# run_script(build_script, env)
		cmd = """ bash -c 'source ./scripts/fuzz/common.sh ; source ./scripts/fuzz/{}.sh' """.format(target) # Put the target thing...
		subprocess.run(cmd, shell=True)





	'''
	elif args.mode == "coverage":
		build_script = SCRIPTS_DIR / "coverage"
		env["OUT_DIR"] = str(COV_BIN_DIR)
		run_script(build_script, env)
	'''

if __name__ == "__main__":
	main()
