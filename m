Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab0D3ROV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:14:21 -0400
Received: from www.tglx.de ([62.245.132.106]:36196 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803Ab0D3RMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:12:45 -0400
Date: Fri, 30 Apr 2010 12:00:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: [ANNOUNCE] 2.6.33.3-rt17
In-Reply-To: <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

Mostly fixups for the VFS scalability fallout.

 4c8acb4: rt: Fix the reminder block accounting for CONFIG_FUNCTION_TRACER
 4eba98c: fs: Use s_inodes not s_files for inode lists
 4329d1a: fs: Fix namespace related hangs
 a0a5961: xfs: Make i_count access non-atomic
 d3d17b8: fs: Fix d_count fallout
 5e022ed: fs: namespace: Fix MNT_MOUNTED handling for cloned rootfs
 4b44047: fs: namespace: Make put_mnt_ns rt aware
 f008b2b: fs: namespace: Fix potential deadlock
 f4c3013: rt: Remove irrelevant CONFIGS from reminder block.
 6994daf: hugetlb: fix infinite loop in get_futex_key() when backed by huge pages

Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git development branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

To build the 2.6.33.3-rt17 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.3.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.3-rt17.bz2

Enjoy !

      tglx

