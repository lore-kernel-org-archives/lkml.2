Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1I1VGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 17:06:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3199 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1I1VGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:06:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6483"; a="123074291"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Update MSM DEBUG_LL support
Date: Wed, 28 Sep 2011 14:05:57 -0700
Message-Id: <1317243959-26383-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.rc0.70.g82660
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches consolidate the current DEBUG_LL code in MSM; moving
the configs to the toplevel DEBUG_LL choice. They also add support
for 8660 and 8960 low level debug.

Patches are based on linux-next-20110927

Stephen Boyd (2):
  msm: Consolidate and move DEBUG_LL to generic ARM Kconfig
  msm: Support DEBUG_LL on MSM8660 and MSM8960

 arch/arm/Kconfig.debug                          |   37 +++++++++++++++++++
 arch/arm/mach-msm/Kconfig                       |   35 ++----------------
 arch/arm/mach-msm/include/mach/debug-macro.S    |   44 ++++++++++++++--------
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   12 ------
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   12 ------
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    5 +++
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   12 ------
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    5 +++
 arch/arm/mach-msm/include/mach/msm_iomap.h      |   12 ++++++
 arch/arm/mach-msm/include/mach/uncompress.h     |   31 ++++++++++++----
 arch/arm/mach-msm/io.c                          |   15 ++++++--
 11 files changed, 125 insertions(+), 95 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

