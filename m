Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182Ab0HGAje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:39:34 -0400
Received: from home.kolivas.org ([59.167.196.135]:45189 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab0HGAjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:39:32 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] 2.6.35-ck1
Date: Sat, 7 Aug 2010 10:39:31 +1000
User-Agent: KMail/1.13.5 (Linux/2.6.35-ck1; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
X-Length: 2035
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008071039.31188.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any workload.


Apply to 2.6.35:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.35/2.6.35-ck1/patch-2.6.35-ck1.bz2


Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.35/2.6.35-ck1/2.6.35-ck1-broken-out.tar.bz2


Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.35/2.6.35-ck1/patches/


Web:
http://kernel.kolivas.org


All -ck patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Each discrete patch contains a brief description of what it does at the top of 
the patch itself.


The most significant change is an updated BFS cpu scheduler. See:
http://lkml.org/lkml/2010/8/6/620

The rest is a resync only since 2.6.34-ck1.


Patch series:

2.6.35-sched-bfs-323.patch
sched-add-above-background-load-function.patch
mm-make_swappiness_really_mean_it.patch
mm-zero_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
mm-kswapd_inherit_prio-1.patch
mm-background_scan.patch
mm-idleprio_prio-1.patch
mm-lru_cache_add_lru_tail.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
cpufreq-bfs_tweaks.patch
ck1-version.patch


Enjoy!

-- 
-ck
