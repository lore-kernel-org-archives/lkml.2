Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab1CGVqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:46:53 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19263 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab1CGVqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:46:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6278"; a="78538810"
From: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: will.deacon@arm.com, jamie.iles@picochip.com, jean.pihet@newoldbits.com,
        robert.richter@amd.com, dwalker@fifo99.com, bryanh@codeaurora.org,
        davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sheetal Sahasrabudhe <sheetals@codeaurora.org>
Subject: [PATCH v2 0/3] ARM: Add Scorpion/ScorpionMP support to perf and Oprofile
Date: Mon,  7 Mar 2011 16:46:44 -0500
Message-Id: <1299534404-25346-1-git-send-email-sheetals@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the following features:
It adds support for Qualcomm Scorpion and ScorpionMP processors to perfevents
and Oprofile.
It adds PMU support for Scorpion and ScorpionMP.
It also updates PMU IRQ identifiers for various Scorpion and ScorpionMP targets.

Sheetal Sahasrabudhe (3):
  msm: Add support for Scorpion and ScorpionMP PMU
  [ARM] perfevents: Add support for Scorpion performance monitors
  [ARM] Oprofile: Add Qualcomm Scorpion and ScorpionMP CPU type

 arch/arm/include/asm/perf_event.h          |    2 +
 arch/arm/kernel/perf_event.c               |   11 +
 arch/arm/kernel/perf_event_msm.c           |  665 ++++++++++++++++++++++++++++
 arch/arm/mach-msm/Makefile                 |    2 +
 arch/arm/mach-msm/include/mach/irqs-7x30.h |    2 +-
 arch/arm/mach-msm/include/mach/irqs-8960.h |    2 +-
 arch/arm/mach-msm/include/mach/irqs-8x50.h |    2 +-
 arch/arm/mach-msm/include/mach/irqs-8x60.h |    2 +-
 arch/arm/mach-msm/pmu.c                    |   35 ++
 arch/arm/oprofile/common.c                 |    4 +
 10 files changed, 723 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/kernel/perf_event_msm.c
 create mode 100644 arch/arm/mach-msm/pmu.c

-- 
1.7.4.1

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum

