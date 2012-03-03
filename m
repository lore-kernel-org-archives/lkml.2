Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2CCEkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 23:40:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62031 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2CCEkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 23:40:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of lucas.demarchi@profusion.mobi designates 10.14.131.13 as permitted sender) smtp.mail=lucas.demarchi@profusion.mobi
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Sat, 3 Mar 2012 01:39:40 -0300
Message-ID: <CAMOw1v5TpPiQG4BLdtDzDTgqdf+9Y49cLvgpD+x0-3nY3Xg12A@mail.gmail.com>
Subject: [ANNOUNCE] kmod 6
To: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!! kmod 6 is out:

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-6.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-6.tar.sign

The first noticeable change is that we are now hosting kmod on
kernel.org. The new repository can be found here:

http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=summary

This version is very shorter than previous and this only indicates we
are reaching a maintenance phase. Everyone is advised to upgrade from
previous versions (including distros packaging kmod 5 and wanting to
freeze in that version). There were some important bugs fixed. Check
NEWS file for more information:
http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=blob;f=NEWS;h=4181097b8334e6145e556fc12ee42922d5751fb3;hb=HEAD


Shortlog is below. Thanks for everyone that helped with this release.

Lucas De Marchi


Dan McGee (1):
      testsuite: libtestsuite depends on individual components

Dave Reisner (5):
      testsuite: add .path member to test struct
      libkmod/module: add kmod_module_apply_filter method
      modinfo: use new apply_filter method to avoid builtins
      find builtins by property, not initstate
      modprobe: show builtin label on --show-depends

Lucas De Marchi (30):
      libkmod-module: probe: Fix ignore-loaded flag not being applied
      testsuite: macronify main function
      testsuite: macronify test definitions
      testsuite: update README file
      testsuite: add tests to modprobe --show-depends
      build-sys: add rule to pack rootfs
      Check if libc has __xstat
      Mark functions with attribute noreturn
      test: remove test-state
      libkmod-module: probe: fix infinite loop with softdeps
      libkmod-index: don't print an error if index doesn't exist
      TODO: add tasks and bug fixes
      testsuite: add test for builtins with modprobe
      kmod-module: lookup: search modules.builtin file too
      testsuite: fix color of unexpected failure
      Downgrade log level when modules.dep{,.bin} don't exist
      Add missing newlines
      libkmod-module: probe: check if module exists for install cmds
      TODO: update and organize items
      libkmod-module: don't treat "coming" as in-kernel
      Move repository to kernel.org
      libkmod-module: fill builtin's name
      libkmod-index: free node when we have only partial match
      man: detail modprobe.blacklist in kcmdline
      Downgrade log message: refcnt file may not exist
      libkmod-index: do not pre-populate mmap
      Fix wrong printf format string
      Add kmod_module_apply_filter() to doc-sections file
      Use upper case after Deprecated in doc
      kmod 6

Wouter van Kesteren (1):
      Fix path.c's function pointer defenitions.
