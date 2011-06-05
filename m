Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1FEFhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 01:37:50 -0400
Received: from home.kolivas.org ([59.167.196.135]:49519 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab1FEFhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 01:37:50 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.39-ck2
Date: Sun, 5 Jun 2011 15:37:43 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.39-ck1; KDE/4.6.2; x86_64; ; )
MIME-Version: 1.0
Message-Id: <201106051537.43488.kernel@kolivas.org>
X-Length: 4750
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and interactivity 
with specific emphasis on the desktop, but suitable to any commodity hardware 
workload.


Apply to 2.6.39(.x):
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.39/2.6.39-ck2/patch-2.6.39-ck2.bz2

Broken out tarball:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.39/2.6.39-ck2/2.6.39-ck2-broken-out.tar.bz2

Discrete patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.39/2.6.39-ck2/patches/

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


The only change from 2.6.39-ck1 is an upgrade to BFS CPU scheduler version 0.406.
A bug that would cause hangs due to an incompatibility with the new block plug
flushing code and BFS was fixed.

Full patchlist:
2.6.39-sched-bfs-406.patch
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
ck2-version.patch

Please enjoy!
お楽しみください
-- 
-ck
