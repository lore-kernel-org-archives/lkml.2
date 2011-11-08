Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab1KHSdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:33:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7781 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KHSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:33:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135802022"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 0/2] MSM8660/8960 DEBUG_LL support and cleanups
Date: Tue,  8 Nov 2011 10:33:02 -0800
Message-Id: <1320777184-22446-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes are based on 3.2-rc1.

Changes since v2:
 * Don't use readl/writel directly in uncompress.h as that's
   kernel functionality and not decompress functionality

Stephen Boyd (2):
  ARM: msm: Consolidate and move DEBUG_LL to DEBUG_LL choice
  msm: Support DEBUG_LL on MSM8660 and MSM8960

 arch/arm/Kconfig.debug                          |   37 ++++++++++++++++
 arch/arm/mach-msm/Kconfig                       |   35 +--------------
 arch/arm/mach-msm/include/mach/debug-macro.S    |   51 ++++++++++++++--------
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |   12 -----
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |   12 -----
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    5 ++
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |   12 -----
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    5 ++
 arch/arm/mach-msm/include/mach/msm_iomap.h      |   12 +++++
 arch/arm/mach-msm/include/mach/uncompress.h     |   39 ++++++++++++++----
 arch/arm/mach-msm/io.c                          |   15 +++++-
 11 files changed, 137 insertions(+), 98 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

