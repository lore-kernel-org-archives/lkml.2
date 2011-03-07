Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1CGGwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:52:44 -0500
Received: from trent.utfs.org ([194.246.123.103]:36054 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1CGGwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:52:42 -0500
Date: Sun, 6 Mar 2011 22:52:38 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCH] minor corrections to Documentation/Changes
Message-ID: <alpine.DEB.2.01.1103062243090.23816@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed the 'mcelog' program had no comment and then ended up "fixing" 
a few more things:

  * reiserfsck -V does not print "reiserfsprogs" (any more?)
  * is "udevinfo" still shipped? udevd certainly is
  * grub2 doesn't have a 'grub' binary
  * add a "# how to get the mcelog version" comment

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

--- linux-2.6-git/Documentation/Changes	2011-01-19 12:27:46.000000000 -0800
+++ linux-2.6-git/Documentation/Changes.edited	2011-03-06 22:25:44.000000000 -0800
@@ -35,7 +35,7 @@ o  util-linux             2.10o
 o  module-init-tools      0.9.10                  # depmod -V
 o  e2fsprogs              1.41.4                  # e2fsck -V
 o  jfsutils               1.1.3                   # fsck.jfs -V
-o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
+o  reiserfsprogs          3.6.3                   # reiserfsck -V
 o  xfsprogs               2.6.0                   # xfs_db -V
 o  squashfs-tools         4.0                     # mksquashfs -version
 o  btrfs-progs            0.18                    # btrfsck
@@ -46,9 +46,9 @@ o  isdn4k-utils           3.1pre1
 o  nfs-utils              1.0.5                   # showmount --version
 o  procps                 3.2.0                   # ps --version
 o  oprofile               0.9                     # oprofiled --version
-o  udev                   081                     # udevinfo -V
-o  grub                   0.93                    # grub --version
-o  mcelog		  0.6
+o  udev                   081                     # udevd --version
+o  grub                   0.93                    # grub --version || grub-install --version
+o  mcelog                 0.6                     # mcelog --version
 o  iptables               1.4.2                   # iptables -V
 
 

-- 
BOFH excuse #225:

It's those computer people in X {city of world}.  They keep stuffing things up.
