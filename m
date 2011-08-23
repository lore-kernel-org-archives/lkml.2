Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab1HWRjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:39:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29318 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab1HWRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:39:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6446"; a="112157106"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/6] mmc: msm_sdcc Various fixes.
Date: Tue, 23 Aug 2011 10:39:12 -0700
Message-Id: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sahitya sent these out back in May, and I wanted to make sure they got
reviewed before pulling them in.

Sahitya Tummala (5):
  mmc: msm_sdcc: Handle error cases in probe
  mmc: msm_sdcc: Enable SDC host->clk only after setting the rate.
  msm: mmc: Remove "pio_irq" resource
  mmc: msm_sdcc: Use MCI_INT_MASK0 for PIO interrupts
  mmc: msm_sdcc: Change initialization order of busclk_timer in probe

Subhash Jadavani (1):
  mmc: msm_sdcc: Handle dma resource not present case

 arch/arm/mach-msm/devices-msm7x00.c |   24 ------------
 arch/arm/mach-msm/devices-qsd8x50.c |   24 ------------
 drivers/mmc/host/msm_sdcc.c         |   67 +++++++++++++++++++++++------------
 drivers/mmc/host/msm_sdcc.h         |    6 +++-
 4 files changed, 49 insertions(+), 72 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

