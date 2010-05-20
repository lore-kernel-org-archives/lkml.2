Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0ETHiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:38:55 -0400
Received: from home.kolivas.org ([59.167.196.135]:35190 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab0ETHix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:38:53 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.34-ck1
Date: Thu, 20 May 2010 17:38:51 +1000
User-Agent: KMail/1.12.4 (Linux/2.6.34-ck1; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005201738.51749.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any workload.


Apply to 2.6.34:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.34/2.6.34-
ck1/patch-2.6.34-ck1.bz2


Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.34/2.6.34-
ck1/2.6.34-ck1-broken-out.tar.bz2


Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.34/2.6.34-
ck1/patches/


Web:
http://kernel.kolivas.org


All -ck patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Each discrete patch contains a brief description of what it does at the top of 
the patch itself.


Updated:
2.6.34-sched-bfs-318.patch
mm-kswapd_inherit_prio-1.patch


New:
mm-zero_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
cpufreq-bfs_tweaks.patch


Full patchlist:
2.6.34-sched-bfs-318.patch
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


Enjoy

-- 
-ck
