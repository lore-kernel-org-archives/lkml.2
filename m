Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2AOXw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 18:52:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53596 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2AOXwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 18:52:25 -0500
MIME-Version: 1.0
Date: Mon, 16 Jan 2012 10:52:23 +1100
X-Google-Sender-Auth: XKBB7i6EcP-FYFfULW7K5Tstey0
Message-ID: <CABqErrFZK0PA_p-esUTBACOo_WFcgQ2FyUst2RyfBGf42htSqg@mail.gmail.com>
Subject: [ANNOUNCE] 3.2-ck1
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

This is an upgrade to BFS 416, trivial bugfixes and a resync from
3.1.0-ck1 . I've changed the versioning to not specify a 3 point
release since it usually applies to successive 3 point releases for
some time.

Apply to 3.2.x:
http://ck.kolivas.org/patches/3.0/3.2/3.2-ck1/patch-3.2-ck1.bz2


Broken out tarball:
http://ck.kolivas.org/patches/3.0/3.2/3.2-ck1/3.2-ck1-broken-out.tar.bz2


Discrete patches:
http://ck.kolivas.org/patches/3.0/3.2/3.2-ck1/patches/


BFS by itself:
http://ck.kolivas.org/patches/bfs/


Web:
http://kernel.kolivas.org


Code blog when I feel like it:
http://ck-hack.blogspot.com/


Each discrete patch usually contains a brief description of what it does at
the top of the patch itself.

Full patchlist:

3.2-sched-bfs-416.patch
mm-minimal_swappiness.patch
mm-enable_swaptoken_only_when_swap_full.patch
mm-drop_swap_cache_aggressively.patch
mm-kswapd_inherit_prio-1.patch
mm-background_scan.patch
mm-idleprio_prio-1.patch
mm-lru_cache_add_lru_tail-2.patch
mm-decrease_default_dirty_ratio-1.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch
hz-no_default_250.patch
hz-raise_max.patch
preempt-desktop-tune.patch
ck1-version.patch

Enjoy!
お楽しみください

--ck
