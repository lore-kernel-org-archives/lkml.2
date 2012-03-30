Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502Ab2C3XUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:20:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59822 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761361Ab2C3XU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:20:26 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Fri, 30 Mar 2012 16:20:25 -0700
Message-ID: <CAOesGMjU5tehTf7+nYQv1_7a=+gGN2hVYUdh1g_BF=WRYj0hgg@mail.gmail.com>
Subject: [GIT PULL] ARM: Two more fixes for merge window fallout
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Apologies for back-to-back fixes pull requests, but one of the patches
below are the kind we'll see posted over and over if we don't send it
in. I hadn't done the full sanity-check of defconfig builds by the
time I sent up the other fixes yesterday or I would have included it
then.

After this we're likely to switch to a more regular frequency of
sending fixes up.



Thanks,

-Olof



The following changes since commit f00e9b11863abdb837e555a2b1e3417e8b5d80dd:

  Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes
(2012-03-29 20:36:18 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

for you to fetch changes up to d3c7de52096a201ac188adb95b8351b90cab11f1:

  ARM: clps711x: fix missing include file (2012-03-30 15:44:48 -0700)

----------------------------------------------------------------
ARM: A few more platform fixes for include file fallout

Two patches, one dealing with the system.h fallout, the other is a missing
linux/bug.h in a place where ARRAY_SIZE() is used.

----------------------------------------------------------------
Olof Johansson (2):
      ARM: fix builds due to missing <asm/system_misc.h> includes
      ARM: clps711x: fix missing include file

 arch/arm/mach-at91/at91x40.c        |    1 +
 arch/arm/mach-at91/setup.c          |    1 +
 arch/arm/mach-clps711x/edb7211-mm.c |    1 +
 arch/arm/mach-h720x/common.c        |    1 +
 arch/arm/mach-imx/mm-imx3.c         |    1 +
 arch/arm/mach-imx/mm-imx5.c         |    1 +
 arch/arm/mach-ixp23xx/core.c        |    1 +
 arch/arm/mach-ixp4xx/common.c       |    1 +
 arch/arm/mach-pxa/raumfeld.c        |    2 ++
 arch/arm/mach-shark/core.c          |    1 +
 arch/arm/mach-w90x900/dev.c         |    1 +
 arch/arm/plat-s3c24xx/cpu.c         |    1 +
 12 files changed, 13 insertions(+)
