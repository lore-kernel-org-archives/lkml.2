Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2IUGVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:21:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50363 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab2IUGVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:21:02 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
Date: Thu, 20 Sep 2012 23:21:01 -0700
Message-ID: <CAOesGMjWcEXubD9ei+r=Xxz9KdJcFMsuk0pEN08nNsas8we3_A@mail.gmail.com>
Subject: Status of arm-soc for 3.7
From: Olof Johansson <olof@lixom.net>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, a heads up for those of you who were planning on coming with
late merge requests: Sorry, but we will probably hold off until 3.8.

We'll still take fixes and probably some small updates. But given all
the moves of platform data and other code shuffling in the tree for
this next merge window, merge conflicts and dependencies are stacking
up quickly right now. I don't want things to get out of control in
that area, which means no more major merges.

What's left to deal with is:

* smp_ops branch, since multiplatform depends on it to allow building
more than one platform.

* bcmring removal hasn't been applied yet, it's not really urgent and
the patches were line wrapped and I forgot about it before I merged
multiplatform and, well, it can just wait until 3.8 now.

* vt8500 device tree conversion had some comments on some of the
bindings. Since the pull request has already come in, I'll revisit it
if it looks like it won't be too messy to merge in.

Beyond that, let me know if you have already sent us a merge request
that we have missed.

Some quick stats:

590 non-merge changesets are queued up through 94 branch merges, which
is fewer patches but about the same number of merges as usual:
 1149 files changed, 29520 insertions(+), 35466 deletions(-)

The cleanup branch this release is substantial: 160 patches alone,
with a diffstat of:
 614 files changed, 9769 insertions(+), 20645 deletions(-)


Some highlights (I'm missing lots, but a few are):

One platform removal: pnx4008
One new platform: bcm2835
Lots of DT updates across the board this release. Tegra has removed
all board files and gone DT-only.
We have a new maintainer for KS8695 (Greg Ungerer) and renewed contributions.
Qualcomm has started cleaning out some stale code from the MSM
platforms, and begin device tree enablement for the latest families.
Exynos4 has been converted to pinctrl and gpiolib.
PRISM2 has DT bindings for pinctrl
The first interrupt controller driver has been added to /drivers/irqchip
OMAP internal bus has been added to /drivers/bus
Lots of moves of platform_data contents into include/linux/platform_data
Moves and removal of other mach-*/include files out of the way to
prepare for multiplatform
Initial multiplatform patch series from Rob Herring


Top 15 authors:

Tony Lindgren (46)
Arnd Bergmann (40)
Uwe Kleine-König (37)
Rob Herring (35)
Shawn Guo (33)
Stephen Warren (27)
Fabio Estevam (23)
Stephen Boyd (20)
Bryan Wu (18)
Laxman Dewangan (18)
Linus Walleij (17)
Chao Xie (12)
Afzal Mohammed (10)
Igor Grinberg (9)
Paul Walmsley (9)


-Olof
