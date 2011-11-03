Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1KCFx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:53:58 -0400
Received: from home.kolivas.org ([59.167.196.135]:54907 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038Ab1KCFx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:53:57 -0400
From: Con Kolivas <con@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] 3.1.0-ck1
Date: Thu, 03 Nov 2011 16:53:16 +1100
Message-ID: <1636461.EdGrGCQCuj@quad>
User-Agent: KMail/4.7.2 (Linux/3.1.0-ck1; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any commodity hardware 
workload.

As it may take some time to get a kernel.org account, I have started hosting 
these patches exclusively on my site for now. 


Apply to 3.1.x:
http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/patch-3.1.0-ck1.bz2


Broken out tarball:
http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/3.1.0-ck1-broken-out.tar.bz2


Discrete patches:
http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/patches/


BFS by itself:
http://ck.kolivas.org/patches/bfs/


Web:
http://kernel.kolivas.org


Code blog when I feel like it:
http://ck-hack.blogspot.com/


Each discrete patch usually contains a brief description of what it does at 
the top of the patch itself.

Full patchlist:

3.1-sched-bfs-414.patch
sched-add-above-background-load-function.patch
mm-minimal_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
mm-kswapd_inherit_prio-1.patch
mm-background_scan.patch
mm-idleprio_prio-1.patch
mm-lru_cache_add_lru_tail-1.patch
mm-decrease_default_dirty_ratio.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
cpufreq-bfs_tweaks.patch
ck1-version.patch


This is mainly a resync with the linux-3.1 kernel apart from the minor 
improvements and cleanups that were committed to the BFS CPU scheduler.


お楽しみ下さい
Please enjoy!

-- 
-ck
