Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1JUE2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 00:28:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23033 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1JUE2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 00:28:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6505"; a="129636100"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 0/2] Update MSM DEBUG_LL support
Date: Thu, 20 Oct 2011 21:28:30 -0700
Message-Id: <1319171312-21113-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.138.g7f41b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a reroll of the MSM DEBUG_LL patches. They incorporate
feedback from Nico and are rebased on top of rmk's debug branch.
My understanding is the debug branch is a stable branch to build
up low-level debug on.

Stephen Boyd (2):
  msm: Consolidate and move DEBUG_LL to generic ARM Kconfig
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
 arch/arm/mach-msm/include/mach/uncompress.h     |   31 ++++++++++----
 arch/arm/mach-msm/io.c                          |   15 +++++-
 11 files changed, 129 insertions(+), 98 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

