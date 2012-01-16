Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2APTUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:20:14 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40649 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069Ab2APTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:20:12 -0500
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 16 Jan 2012 17:19:49 -0200
Message-ID: <CAMOw1v4SQ6FpKgy+t+e3YrpR2bP41VBouU5Dcj_vBH8pirZ0cA@mail.gmail.com>
Subject: [ANNOUNCE] kmod 4
To: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!!

I'm glad to announce kmod 4! Signed tarball is available at

http://packages.profusion.mobi/kmod/kmod-4.tar.xz
http://packages.profusion.mobi/kmod/kmod-4.tar.sign

With this version we are now feature-complete. All tools and features
from module-init-tools are implemented. Man pages and API doc were
added as well.

Thanks a lot to people from Archlinux, especially Dave Reisner, who
helped with bug reports and ironing them out.

We also received report from one more architecture being tested: hppa.


Please check NEWS file that we ship with kmod for more information.


With this version we postponed the API break that was planned and
decided to only add a few missing API, solve the bugs people reported
and make docs and man pages. Shortlog is below.


Lucas De Marchi

---
Dave Reisner (4):
      tools/modinfo: exit non-zero on module not found
      tools/modprobe: exit non-zero on module not found with --all
      modprobe: check for EPERM on insertion
      rmmod: behavior more like m-i-t's rmmod

Gustavo Sverzut Barbieri (1):
      modprobe: show is independent from verbose level.

Jan Alexander Steffens (heftig) (1):
      depmod: Postpone creation of module array

Lucas De Marchi (70):
      Revert "tools/kmod-depmod: fix aliasing warning"
      config: check if opening /proc/cmdline succeeded
      Replace NAME_MAX with PATH_MAX for module aliases
      modprobe: fix error path when loading dependencies
      Update copyright
      doc: fix comments format
      Match param names on header and source code
      doc: fix order of param descriptions
      doc: fix broken links to other functions
      doc: add gtk-doc to generate documentation
      doc: organize sections
      build-sys: do not run configure in autogen.sh
      README: add more information
      build-sys: give recommended configure options for hacking
      doc: fix out of tree build
      TODO: add tasks to modprobe
      config: be reliable againt syntax errors in configs
      build-sys: allow building without having gtk-doc installed
      build-sys: create symlinks instead of building separate tools
      build-sys: build tests as part of check phase
      build-sys: workaround libtool issue with argv[0]
      TODO: add task to modprobe
      build-sys: fix build with zlib/xz after private lib
      Fix error code returned on module removal
      config: deprecate 'include' and 'config' commands
      modprobe: adhere do coding style
      autogen.sh: configure with 3-clicks + paste
      modprobe: break dependency loop by checking if module is loaded
      test: add check of module's state
      modprobe: show if module is in kernel
      rename doc dir to man
      build-sys: fix clean rule removing tracked files
      man: convert depmod.d.sgml to xml and update it
      build-sys: build man pages
      man: build modprobe.d man page
      man: build modules.dep{,.bin} man pages
      man: build depmod man page
      man: build insmod man page
      man: build lsmod man page
      man: build rmmod man page
      man: build modprobe man page
      man: build modinfo man page
      modprobe: rework module insertion without tree traversing
      TODO: update differences with m-i-t
      modprobe: rework module removal without tree traversing
      TODO: update tasks
      modprobe: fix leak on error path
      modprobe: abort on dependency loop that cannot be broken
      TODO: add code unification to list of tasks
      build-sys: rename autogen.sh to bootstrap and keep a symlink
      build-sys: add script to bootstrap and configure
      libkmod-private: allow to get aliases from config
      config: add exported iterator functions
      config: let softdeps dump their data
      modprobe: dump configuration
      depmod: adhere to coding style
      Reduce scope of counter variable
      depmod: fix idx calculation after postponed array creation
      kmod_new(): deal with relative paths for dirname
      depmod: deal with relative root dir
      Update documentation with recent changes
      libkmod: store prefix of each index
      libkmod: export enum kmod_index and rename members
      libkmod-util: adhere to coding style
      libkmod-util: add helper function to write to fd
      libkmod: dump index files
      modprobe: dump indexes as well
      Add doc to kmod_dump_index
      build-sys: add release helpers
      kmod 4

Robby Workman (6):
      doc: Import sgml manpages from module-init-tools repo
      doc/modprobe.d.sgml: Various touchups
      doc/depmod.d.sgml: Various touchups; mostly s/depmod.conf/depmod.d/g
      doc/depmod.sgml: Remove refs to depmod.conf
      doc/depmod.sgml: Remove references to legacy map files
      doc/modprobe.sgml: Various updates wrt inclusion with kmod

Rolf Eike Beer (1):
      tools/kmod-depmod: fix aliasing warning

root (1):
      tools/kmod-depmod: fix aliasing warning
