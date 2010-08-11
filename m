Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0HKSAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:00:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57823 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197Ab0HKSAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:00:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6071"; a="50540440"
Subject: [GIT PULL] MSM updates for 2.6.36
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 10:58:45 -0700
Message-ID: <1281549525.2801.13.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is an unfortunately small MSM pull request. I wish I could have
included more than this. It does include MMC support for trout (G1), but
that's about the most exciting thing here.

Please consider pulling this.

Daniel


The following changes since commit 3260e5293727f16ffdce9a6a6203fd9a6b149e58:

  arm: mm: Don't free prohibited memmap entries (2010-06-15 13:19:55 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-core

Daniel Walker (2):
      arm: msm: trout: add trout specific gpio interrupts
      arm: msm: trout add mmc support

Gregory Bean (1):
      arm: msm: Fix section mismatch in smd.c.

Huang Weiyi (1):
      arm: msm: remove unused #include <linux/version.h>

Sahitya Tummala (2):
      msm: trout: Remove extern declaration from source file
      msm: mmc: Add msm prefix to platform data structure

 arch/arm/mach-msm/Makefile             |    2 +-
 arch/arm/mach-msm/acpuclock-arm11.c    |    1 -
 arch/arm/mach-msm/board-trout-gpio.c   |  115 ++++++++++++++++++++
 arch/arm/mach-msm/board-trout-mmc.c    |  186 ++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/board-trout.c        |   11 ++
 arch/arm/mach-msm/clock.c              |    1 -
 arch/arm/mach-msm/devices-msm7x00.c    |    3 +-
 arch/arm/mach-msm/include/mach/board.h |    4 +
 arch/arm/mach-msm/include/mach/mmc.h   |    2 +-
 arch/arm/mach-msm/smd.c                |    2 +-
 drivers/mmc/host/msm_sdcc.c            |    2 +-
 drivers/mmc/host/msm_sdcc.h            |    2 +-
 12 files changed, 323 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-trout-mmc.c

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

