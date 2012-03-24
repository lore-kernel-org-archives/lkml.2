Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2CXJdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 05:33:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63621 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2CXJdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 05:33:50 -0400
MIME-Version: 1.0
Date: Sat, 24 Mar 2012 20:33:48 +1100
X-Google-Sender-Auth: fsxNm4Dzu0MIf9hLTKBUzDx_LWA
Message-ID: <CABqErrG2CzmH_RH2vfhGi2nd6eeuXZyemW6j_=9KRZ82kNKJGg@mail.gmail.com>
Subject: [ANNOUNCE] 3.3.0-ck1
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are patches designed to improve system responsiveness and
interactivity with specific emphasis on the desktop, but suitable to
any commodity hardware workload.

Apply to 3.3.x:
http://ck.kolivas.org/patches/3.0/3.3/3.3-ck1/patch-3.3-ck1.bz2
or
http://ck.kolivas.org/patches/3.0/3.3/3.3-ck1/patch-3.3-ck1.lrz


Broken out tarball:
http://ck.kolivas.org/patches/3.0/3.3/3.3-ck1/3.3-ck1-broken-out.tar.bz2
or
http://ck.kolivas.org/patches/3.0/3.3/3.3-ck1/3.3-ck1-broken-out.tar.lrz

Discrete patches:
http://ck.kolivas.org/patches/3.0/3.3/3.3-ck1/patches/


BFS by itself:
http://ck.kolivas.org/patches/bfs/


Web:
http://kernel.kolivas.org


Code blog when I feel like it:
http://ck-hack.blogspot.com/


This is an upgrade to BFS 420 (see separate post to this list for
description), trivial bugfixes and a resync from 3.2.0-ck1 . The
following patches have also been dropped:

-mm-background_scan.patch
-mm-lru_cache_add_lru_tail-2.patch

The Virtual Memory subsystem has changed so much it's hard to know if
these patches do what they originally intended to do, nor if they are
helpful any more. In the absence of being able to test their validity,
it seems safer to just drop them.


Each discrete patch usually contains a brief description of what it does at
the top of the patch itself.

Full patchlist:

3.3-sched-bfs-420.patch
mm-minimal_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
mm-kswapd_inherit_prio-1.patch
mm-idleprio_prio-1.patch
mm-decrease_default_dirty_ratio-1.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
ck1-version.patch

This is also a good time to plug an updated lrzip which created the
.lrz files above and is particularly good at compressing code such as
the linux kernel and the latest version (0.612) features faster and
tighter compression than ever and a liblrzip library allowing lrzip
support to be added to any other application. See:

https://freecode.com/projects/long-range-zip

Enjoy!
お楽しみ下さい

--
-ck
