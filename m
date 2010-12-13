Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab0LMBU2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 12 Dec 2010 20:20:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34393 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0LMBU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:20:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6195"; a="66336621"
From: ykaoua@qualcomm.com
X-IronPort-AV: E=Sophos;i="4.59,332,1288594800"; 
   d="scan'208";a="35903473"
To: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>
Subject: [PATCH 0/5 v3] SMP support for msm
Date: Sun, 12 Dec 2010 17:20:15 -0800
Message-Id: <1292203221-2609-1-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Ohlstein <johlstei@codeaurora.org>

This series adds support for SMP on msm targets, and specifically adds
support for SMP on the msm8x60. This version is rebased on top of
Russell's SMP and gic patches, and doesn't need to change dma-mapping.

Jeff Ohlstein (3):
  msm: timer: SMP timer support for msm
  msm: hotplug: support cpu hotplug on msm
  msm: add SMP support for msm

Stepan Moskovchenko (1):
  msm: scm-boot: Support for setting cold/warm boot addresses

Stephen Boyd (1):
  msm: Secure Channel Manager (SCM) support

 arch/arm/mach-msm/Kconfig                       |    5 +
 arch/arm/mach-msm/Makefile                      |    4 +
 arch/arm/mach-msm/headsmp.S                     |   43 ++++
 arch/arm/mach-msm/hotplug.c                     |   88 +++++++
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    6 +-
 arch/arm/mach-msm/include/mach/smp.h            |    2 +
 arch/arm/mach-msm/io.c                          |    1 +
 arch/arm/mach-msm/platsmp.c                     |  123 ++++++++++
 arch/arm/mach-msm/scm-boot.c                    |   39 +++
 arch/arm/mach-msm/scm-boot.h                    |   38 +++
 arch/arm/mach-msm/scm.c                         |  287 +++++++++++++++++++++++
 arch/arm/mach-msm/scm.h                         |   41 ++++
 arch/arm/mach-msm/timer.c                       |  137 +++++++++--
 13 files changed, 790 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm/mach-msm/headsmp.S
 create mode 100644 arch/arm/mach-msm/hotplug.c
 create mode 100644 arch/arm/mach-msm/platsmp.c
 create mode 100644 arch/arm/mach-msm/scm-boot.c
 create mode 100644 arch/arm/mach-msm/scm-boot.h
 create mode 100644 arch/arm/mach-msm/scm.c
 create mode 100644 arch/arm/mach-msm/scm.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

