Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1BEAVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 19:21:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1BEAVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 19:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:cc;
        b=w6w+5EwlfdUuXIyx0oij/j1LP3SHdkNfYljgt+o83yCj6rQ0PSPalcZjKKvJLNLZmd
         XcF7KFZLaaPYvw3ChtYwc5tdRW2xD01Z799NVsLVFA6MlCTSpIiMCwDagXcE1p/9bktF
         UCUckqP6B+vwieLkYuTxdpwYGtsbOllqbIr0Q=
Message-ID: <4d4c9800.664bcc0a.41bb.3f0d@mx.google.com>
Date: Fri, 04 Feb 2011 16:21:20 -0800 (PST)
Subject: [GIT PULL 00/68] tools/perf: Makefile: Remove [git] cruft
From: Michael Witten <mfwitten@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made many very fine-grained commits that widdle away
dead code mainly from "$REPO/tools/perf/Makefile"; for
the most part, any code that is currently being used
was not altered (even if it could be improved).

These changes apply and build cleanly upon fe4b04fa31a6dcf4358aa84cf81e5a7fd079469b:

  perf: Cure task_oncpu_function_call() races (2011-02-03 12:14:43 +0100)

and they are available in the git repository here:

  git://github.com/mfwitten/linux-2.6.git perf-makefile

Michael Witten (68):
      tools/perf: Makefile: Remove SNPRINTF_RETURNS_BOGUS
      tools/perf: Makefile: Remove FREAD_READS_DIRECTORIES
      tools/perf: Makefile: Remove SHA1/SSL cruft
      tools/perf: Makefile: Remove CURLDIR and EXPATDIR
      tools/perf: Makefile: Remove NO_D_{INO,TYPE}_IN_DIRENT
      tools/perf: Makefile: Remove NO_C99_FORMAT
      tools/perf: Makefile: Remove NO_STRCASESTR
      tools/perf: Makefile: Remove NO_MEMMEM
      tools/perf: Makefile: Remove NO_STRTOUMAX and NO_STRTOULL
      tools/perf: Makefile: Remove NO_SETENV
      tools/perf: Makefile: Remove NO_UNSETENV
      tools/perf: Makefile: Remove NO_MKDTEMP
      tools/perf: Makefile: Remove NO_SYMLINK_HEAD
      tools/perf: Makefile: Remove NO_SVN_TESTS
      tools/perf: Makefile: Remove NEEDS_LIBICONV
      tools/perf: Makefile: Remove NEEDS_SOCKET
      tools/perf: Makefile: Remove NO_MMAP
      tools/perf: Makefile: Remove NO_PTHREADS
      tools/perf: Makefile: Remove NO_PREAD
      tools/perf: Makefile: Remove NO_FAST_WORKING_DIRECTORY
      tools/perf: Makefile: Remove NO_TRUSTABLE_FILEMODE
      tools/perf: Makefile: Remove NO_IPV6 and NO_SOCKADDR_STORAGE
      tools/perf: Makefile: Remove NO_ICONV and OLD_ICONV
      tools/perf: Makefile: Remove NO_DEFLATE_BOUND
      tools/perf: Makefile: Remove CC_LD_DYNPATH and NO_R_TO_GCC_LINKER
      tools/perf: Makefile: Remove NO_NSEC, USE_NSEC, and USE_ST_TIMESPEC
      tools/perf: Makefile: Remove USE_STDEV
      tools/perf: Makefile: Remove NO_ST_BLOCKS_IN_STRUCT_STAT
      tools/perf: Makefile: Remove NO_PERL_MAKEMAKER
      tools/perf: Makefile: Remove INTERNAL_QSORT
      tools/perf: Makefile: Remove NO_EXTERNAL_GREP
      tools/perf: Makefile: Remove NO_FINK and NO_DARWIN_PORTS
      tools/perf: Makefile: Remove NO_SYS_SELECT_H
      tools/perf: Makefile: Remove NO_PERL
      tools/perf: Makefile: Remove SCRIPT_PERL
      tools/perf: Makefile: Remove PERL_PATH_SQ
      tools/perf: Makefile: Remove unnecessary uname calls
      tools/perf: Makefile: Remove `sh -c'
      tools/perf: Makefile: Remove BUILT_INS and QUIET_BUILT_IN
      tools/perf: Makefile: Remove NO_HSTRERROR
      tools/perf: Makefile: Remove RUNTIME_PREFIX
      tools/perf: Makefile: Remove DIR_HAS_BSD_GROUP_SEMANTICS and FORCE_DIR_SET_GID
      tools/perf: Makefile: Remove COMPAT_{CFLAGS,OBJS}
      tools/perf: Makefile: Actually use $(SCRIPTS)
      tools/perf: Makefile: Remove TEST_PROGRAMS
      tools/perf: Makefile: Remove EXTRA_PROGRAMS
      tools/perf: Makefile: Remove unused SHELL_PATH_SQ portions
      tools/perf: Makefile: Remove NEEDS_NSL, NO_UINTMAX_T, NO_INET_{N,P}TON
      tools/perf: Makefile: Remove unused test for V=2
      tools/perf: Makefile: Remove useless exports
      tools/perf: Makefile: Remove unused QUIET_SUBDIR{0,1}
      tools/perf: Makefile: Remove TAR and RPMBUILD
      tools/perf: Makefile: Remove PTHREAD_LIBS
      tools/perf: Makefile: Remove Maintainer's dist rules and commands
      tools/perf: Makefile: Remove distclean target
      tools/perf: Makefile: Remove Test suite coverage testing
      tools/perf: Makefile: Remove PRINT_DIR and NO_SUBDIR
      tools/perf: Makefile: Remove `export DESTDIR'
      tools/perf: Makefile: Remove `X'
      tools/perf: Makefile: Convert `double-colon rules' to `ordinary rules'
      tools/perf: Makefile: Remove `configure' target
      tools/perf: Makefile: Remove NO_CURL
      tools/perf: Makefile: Remove @@PERF_VERSION@@ substitution
      tools/perf: Makefile: Remove vestigial git rules
      tools/perf: Makefile: Remove echo line
      tools/perf: Makefile: Remove template_instdir
      tools/perf: Makefile: Remove `export perfexec_instdir'
      tools/perf: Makefile: Remove PERF-BUILD-OPTIONS

 tools/perf/.gitignore      |    1 -
 tools/perf/Makefile        |  576 ++------------------------------------------
 tools/perf/util/exec_cmd.c |   19 --
 tools/perf/util/util.h     |   26 --
 4 files changed, 18 insertions(+), 604 deletions(-)

Sincerely,
Michael Witten
