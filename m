Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1HKMiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:38:12 -0400
Received: from home.kolivas.org ([59.167.196.135]:42554 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab1HKMiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:38:10 -0400
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Aug 2011 08:38:09 EDT
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: 3.0.0-ck1
Date: Thu, 11 Aug 2011 22:10:25 +1000
User-Agent: KMail/1.13.6 (Linux/3.0.0-ck1; KDE/4.6.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108112210.25459.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any commodity hardware 
workload.

I dedicate this release to the most unlikely recipient - the republic of Nauru 
after my recent trip there. (See my blog for why I was there)


Apply to 3.0(.x):
http://www.kernel.org/pub/linux/kernel/people/ck/patches/3.0/3.0.0-
ck1/patch-3.0.0-ck1.bz2


Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/3.0/3.0.0-ck1/3.0.0-
ck1-broken-out.tar.bz2


Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/3.0/3.0.0-
ck1/patches/


All -ck patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


BFS by itself:
http://ck.kolivas.org/patches/bfs/


Web:
http://kernel.kolivas.org


Code blog when I feel like it:
http://ck-hack.blogspot.com/


Each discrete patch contains a brief description of what it does at the top of 
the patch itself.


Full patchlist:

3.0-sched-bfs-406.patch
sched-add-above-background-load-function.patch
mm-zero_swappiness.patch
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


Apart from major surgery required to get BFS to play nicely with the 3.0 
scheduler changes, the only change from the last -ck release is the 
reinstatement of the cpu frequency tweaks designed to optimise BFS' 
performance on the slower frequency changing multicore CPUs by allowing them 
to speed up easier and harder for them to throttle down.


お楽しみください
Please enjoy!

-- 
-ck
