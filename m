Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2LRBUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:20:55 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39572 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2LRBUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:20:54 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 20:20:54 EST
Message-ID: <50cfc309.64093c0a.7948.05b1@mx.google.com>
Date: Mon, 17 Dec 2012 17:12:41 -0800 (PST)
From: rob@landley.net
Subject: [PATCH 0/3] build 3.7 kernel without perl
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before 2.6.25 building Linux never required perl. This patch series removes
the requirement from basic kernel builds (tested on i686, x86_64, arm, mips,
powerpc, sparc, sh4, and m68k). Now updated to 3.7, with the UAPI stuff.

Earlier versions of these patches were posted to the mailing list once or twice:

http://lkml.indiana.edu/hypermail/linux/kernel/1201.2/02849.html
http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/00093.htm
http://lkml.indiana.edu/hypermail/linux/kernel/0909.2/01661.html
http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00772.html
http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00148.html
http://lkml.indiana.edu/hypermail/linux/kernel/0802.1/4393.html

They've also been posted individually rather than as a series:
http://lkml.indiana.edu/hypermail/linux/kernel/1101.2/00650.html
http://lkml.indiana.edu/hypermail/linux/kernel/1101.2/00115.html

Mentioned during related perl removal patches from other people:
http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/02145.html

And so on. The most up to date version of these patches is always available at
http://landley.net/hg/aboriginal in the sources/patches directory.
Specifically, check:

http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-capflags.patch
http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-headers.patch
http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-timeconst.patch

(Earlier versions had the kernel version number in the filename, so you'll have
to dig in the repository a bit to find them if you want the version for an
older kernel.)

Mostly people just copy the patches into their local projects (ala
https://github.com/rofl0r/sabotage/tree/master/KEEP ) but I'm reposting
them to linux-kernel after Gentoo considered using these patches, but didn't 
because they weren't upstream:
  https://bugs.gentoo.org/show_bug.cgi?id=421483
