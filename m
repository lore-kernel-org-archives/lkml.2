Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab0LODt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:49:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39884 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab0LODt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:49:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66872366"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 0/7] msm: Support for Qualcomm MSM8960
Date: Tue, 14 Dec 2010 19:49:14 -0800
Message-Id: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial support for the Qualcomm MSM8960 target.

Stepan Moskovchenko (7):
  msm: io: I/O register definitions for MSM8960
  msm: Physical offset for MSM8960
  msm: irqs-8960: Interrupt map for MSM8960
  msm: Board file for MSM8960 simulator
  msm: timer: Timer support for MSM8960
  msm: Makefile cleanup
  msm: Build support for the MSM8960 target

 arch/arm/mach-msm/Kconfig                       |   16 ++
 arch/arm/mach-msm/Makefile                      |   20 +-
 arch/arm/mach-msm/board-msm8960.c               |   71 ++++++
 arch/arm/mach-msm/include/mach/io.h             |    1 +
 arch/arm/mach-msm/include/mach/irqs-8960.h      |  293 +++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/irqs.h           |    2 +
 arch/arm/mach-msm/include/mach/memory.h         |    2 +
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |   55 +++++
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 +
 arch/arm/mach-msm/io.c                          |   14 +
 arch/arm/mach-msm/timer.c                       |    3 +-
 11 files changed, 466 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8960.c
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-8960.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

