Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1CXFe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:34:58 -0400
Received: from home.kolivas.org ([59.167.196.135]:35785 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab1CXFe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:34:56 -0400
X-Greylist: delayed 1772 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 01:34:55 EDT
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38-ck1
Date: Thu, 24 Mar 2011 16:05:20 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.38-ck1; KDE/4.6.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103241605.20645.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any workload.


Apply to 2.6.38:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.38/2.6.38-ck1/patch-2.6.38-ck1.bz2

Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.38/2.6.38-ck1/2.6.38-ck1-broken-out.tar.bz2

Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.38/2.6.38-ck1/patches/

All -ck patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Web:
http://kernel.kolivas.org

Code blog when I feel like it:
http://ck-hack.blogspot.com/

Each discrete patch contains a brief description of what it does at the top of 
the patch itself.

This has just been a resync since the last -ck release.


Full patchlist:

2.6.38-sched-bfs-363.patch
sched-add-above-background-load-function.patch
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


I'd also like this opportunity to make a small plug for my compression
application, lrzip, which now features full compression and decompression
to/from STDIN/STDOUT and high grade password encryption, and is now
heavily multithreaded on both compression and decompression cycles.
 It can be downloaded here:
http://lrzip.kolivas.org

See this post for the evolution details:
http://ck-hack.blogspot.com/2011/03/lrzip-0600-stdinstdout-and-encryption.html

And see this post about using it for a kernel compression exercise:
http://ck-hack.blogspot.com/2010/11/lrzip-0520-and-massive-kernel.html

Please enjoy!
お楽しみください

-- 
-ck
