Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1CJEot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:44:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55629 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1CJEom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:44:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="78880698"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 0/3] Peripheral image loader (PIL)
Date: Wed,  9 Mar 2011 20:44:31 -0800
Message-Id: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.203.g07873
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for PIL, a peripheral image loader.
More details can be found in the third patch or the second
patch's commit text.

Saravana Kannan (1):
  msm: documentation: Add pil documentation

Stephen Boyd (2):
  msm: 8660: Add clock control regions to iomap
  msm: Peripheral Image Loader (PIL) driver

 Documentation/arm/msm/pil.txt                      |  267 ++++++++++
 arch/arm/mach-msm/Kconfig                          |   13 +
 arch/arm/mach-msm/Makefile                         |    2 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |    8 +
 arch/arm/mach-msm/include/mach/peripheral-loader.h |   23 +
 arch/arm/mach-msm/io.c                             |    2 +
 arch/arm/mach-msm/peripheral-loader.c              |  402 +++++++++++++++
 arch/arm/mach-msm/peripheral-loader.h              |   38 ++
 arch/arm/mach-msm/peripheral-reset.c               |  528 ++++++++++++++++++++
 9 files changed, 1283 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm/msm/pil.txt
 create mode 100644 arch/arm/mach-msm/include/mach/peripheral-loader.h
 create mode 100644 arch/arm/mach-msm/peripheral-loader.c
 create mode 100644 arch/arm/mach-msm/peripheral-loader.h
 create mode 100644 arch/arm/mach-msm/peripheral-reset.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

