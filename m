Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2FSW6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:58:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56940 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2FSW5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:57:53 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 19 Jun 2012 19:57:32 -0300
Message-ID: <CAMOw1v5=TRPgk0PyW3sS=+ak4O28mqU6ujO8yf-WZYaKSutc5Q@mail.gmail.com>
Subject: [ANNOUNCE] kmod 9
To: linux-modules <linux-modules@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!

kmod 9 is out:

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-9.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-9.tar.sign

Mainly improvements to the testsuite but users will mostly notice the
bugfixes and that now depmod checks for errors while writing the
indexes. Also some small fixes to libkmod while dealing with
compressed modules. Check the NEWS file fora additional information.

Shortlog is below

Lucas De Marchi

---

Dan McGee (3):
      testsuite: ship testsuite/rootfs unzipped
      test-conversion: convert test-blacklist to new infrastructure
      test-conversion: convert test-get-dependencies to new infrastructure

Dave Reisner (4):
      libkmod-file: gracefully handle errors from zlib
      depmod: report failures in loading symbols
      bootstrap-configure: quote command line arg expansion
      bootstrap: remove unnecessary echo

Josh Boyer (1):
      doc: Don't reference /etc/modprobe.conf

Lucas De Marchi (44):
      Remove dead assignment
      Return error instead of always 0
      Remove dead increment
      Revert "libkmod: make sure to export kmod_log"
      build: remove private symbol from linker script
      build-sys: distribute testsuite
      build-sys: copy rootfs to another directory
      libkmod-util: copy macros for unaligned access from BlueZ
      libkmod-hash: use generic function for unaligned access
      libkmod-index: use generic function for unaligned access
      Don't use __ for attribute defines
      Silence clang warnings with __unused__ attribute
      testsuite: fix find_module() finding wrong module
      build-sys: provide --sysconfdir to make distcheck flags
      testsuite: rename rootfs dir
      libkmod-util: add missing stdbool.h include
      testsuite: separate insert and delete rootfs from modinfo
      testsuite: check if rootfs dir is dirty before running
      testsuite: trap calls to mkdir
      testsuite: add mkdir_p implementation
      testsuite: create initstate file upon fake init_module()
      testsuite: set default init_module behavior to mimic kernel's
      testsuite: check if module is in kernel for return code
      testsuite: add test for softdep loops
      libkmod-util: split function for usec conversion
      testsuite: create additional pipe to monitor child
      testsuite: add timeout for each test
      testsuite: allow to export custom env vars
      testsuite: add test for install-commands loop
      libkmod-index: protect ourselves from corrupted indexes
      testsuite: Fix test description
      TODO: update tasks
      libkmod-config: refactor functions to get config
      tools: rename source files
      build-sys: add missing header to fix distcheck
      Remove ifdef for building tools not bundled
      depmod: don't return error if modules.builtin don't exist
      depmod: fail if any index could not be created
      depmod: fix coding-style issue in array declaration
      depmod: return error when index is truncated due to ENOSPC
      depmod: use ferror and fclose to check for error
      build-sys: Make dirs writable on rootfs creation
      build-sys: allow compressed modules in testsuite
      kmod 9

Mike Frysinger (2):
      libkmod: make sure to export kmod_log
      libkmod: move function to the only file using it
