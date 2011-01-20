Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1ATUdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:33:20 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20889 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab1ATUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:33:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71062568"
From: Daniel Walker <dwalker@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org, Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 0/7] Nexus One Support
Date: Thu, 20 Jan 2011 12:32:38 -0800
Message-Id: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds basic Nexus One support which includes a booting
kernel, and functional MMC .

Most people won't be able to use this yet unfortunately because
you need a serial cable to get any output. However, it's a start.

Brian Swetland (1):
  [ARM] msm: qsd8k memory base is at 0x20000000

Daniel Walker (6):
  msm: qsd8x50: add uart platform data
  msm: qsd8x50: add acpuclock code
  msm: mahimahi: add mahimahi board file
  msm: mahimahi: add in mmc support code
  msm: mahimahi: add gpio pin muxing code
  msm: mahimahi: initialize mmc at start up

 arch/arm/mach-msm/Kconfig              |    8 +-
 arch/arm/mach-msm/Makefile             |    5 +-
 arch/arm/mach-msm/Makefile.boot        |    5 +
 arch/arm/mach-msm/acpuclock-qsd8x50.c  |  457 ++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/board-mahimahi-mmc.c |  238 +++++++++++++++++
 arch/arm/mach-msm/board-mahimahi.c     |   52 +++-
 arch/arm/mach-msm/board-mahimahi.h     |  147 ++++++++++
 arch/arm/mach-msm/devices-qsd8x50.c    |   42 +++
 arch/arm/mach-msm/include/mach/board.h |    1 +
 9 files changed, 942 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/mach-msm/acpuclock-qsd8x50.c
 create mode 100644 arch/arm/mach-msm/board-mahimahi-mmc.c
 create mode 100644 arch/arm/mach-msm/board-mahimahi.h

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
