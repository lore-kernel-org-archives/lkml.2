Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab2HVXAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:00:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19782 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab2HVXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:00:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6812"; a="226086638"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] 8660 DT fixlets
Date: Wed, 22 Aug 2012 16:00:12 -0700
Message-Id: <1345676414-16635-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two small fixes to 8660 DT support so that it boots up
and gets interrupts and so that we can build the dtb via
kernel Makefiles with 'make dtbs'.

Stephen Boyd (2):
  ARM: MSM: Add handle_irq handler for 8660 DT machine
  ARM: MSM: Add msm8660-surf.dts to Makefile.boot

 arch/arm/mach-msm/Makefile.boot   | 2 ++
 arch/arm/mach-msm/board-msm8x60.c | 1 +
 2 files changed, 3 insertions(+)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

