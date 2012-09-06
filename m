Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab2IFTiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:38:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62863 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759424Ab2IFTiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:38:16 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 6 Sep 2012 16:37:55 -0300
Message-ID: <CAMOw1v6MYW6O2f4AR9yRvh200j5R6mFTRqDT3TFbG-TjknmUmw@mail.gmail.com>
Subject: [ANNOUNCE] kmod 10
To: linux-modules <linux-modules@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!

kmod 10 is out:

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-10.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-10.tar.sign

The major change was the addition of a flag in
kmod_module_probe_insert() to keep the previous behavior of
module-init-tools regarding blacklisted modules.

Other than that, improvements to testsuite and man pages. I also
re-licensed the testsuite as LGPL. If anyone wants to use in his own
project and LGPL doesn't fit your needs, let me know.

Shortlog is below

Cheers!
Lucas De Marchi

---

Colin Walters (1):
      build-sys: Add --disable-manpages option

Dave Reisner (10):
      Implicitly run 'make rootfs' with 'make check'
      module: support reading coresize from /sys if supported
      build-sys: disable jobserver for rootfs target
      man/modprobe: clarify --dirname option
      man/modinfo: document --basedir option
      man/modinfo: document longopts for field shortcuts
      man/modinfo: specify each option in separate <term> tag
      man/modprobe: specify each option in separate <term> tag
      man/depmod: specify each option in separate <term> tag
      man/rmmod: specify each option in separate <term> tag

Lucas De Marchi (10):
      testsuite: use right offset for module name
      testsuite: re-license under LGPL
      Use #pragma once instead of #ifndef
      build-sys: add 'man' entry in summary
      README: let people know they don't need to subscribe
      libkmod-module: Add KMOD_PROBE_APPLY_BLACKLIST_ALIAS_ONLY flag
      modprobe: Unconditionally use KMOD_PROBE_APPLY_BLACKLIST_ALIAS_ONLY
      TODO: deprecate use of rmmod -w
      Remove test directory
      kmod 10

Martin Pitt (2):
      testsuite: path wrapper: Fix open() with 3 arguments
      testsuite preload: Factorize into macros, add more stat and open variants
