Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1AFFTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 00:19:11 -0500
Received: from home.kolivas.org ([59.167.196.135]:34045 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab1AFFTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 00:19:09 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.37-ck1
Date: Thu, 6 Jan 2011 16:19:06 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.37-ck1; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
X-Length: 2291
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061619.06992.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any workload.


Apply to 2.6.37:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.37/2.6.37-
ck1/patch-2.6.37-ck1.bz2

Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.37/2.6.37-
ck1/2.6.37-ck1-broken-out.tar.bz2

Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.37/2.6.37-
ck1/patches/

All -ck patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Web:
http://kernel.kolivas.org

Code blog when I feel like it:
http://ck-hack.blogspot.com/

Each discrete patch contains a brief description of what it does at the top of 
the patch itself.


The most significant change is an updated BFS CPU scheduler, up to version 
0.363. See the announce of that patch for the changelog. The rest is a resync.


2.6.37-sched-bfs-363.patch
sched-add-above-background-load-function.patch
mm-make_swappiness_really_mean_it.patch
mm-zero_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
mm-kswapd_inherit_prio-1.patch
mm-background_scan.patch
mm-idleprio_prio-1.patch
mm-lru_cache_add_lru_tail.patch
mm-decrease_default_dirty_ratio.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
cpufreq-bfs_tweaks.patch
ck1-version.patch



I'll be offline shortly and in Japan for a few weeks so I'll be unlikely to 
respond to any emails in that time.

Enjoy!
Con
-- 
-ck
