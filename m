Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1HYWJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:09:03 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3574 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab1HYWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:09:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6449"; a="112827803"
Date: Thu, 25 Aug 2011 15:08:58 -0700
From: David Brown <davidb@codeaurora.org>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] mmc: msm_sdcc: Fixes for 3.2
Message-ID: <20110825220858.GA13652@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 93ee7a9340d64f20295aacc3fb6a22b759323280:

  Linux 3.1-rc2 (2011-08-14 15:09:08 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-sdcc

Alexander Tarasikov (2):
      msm: Fix a typo in MSM SDCC driver gpio setup
      msm: Implement init_card operation for MSM SDCC

Sahitya Tummala (5):
      mmc: msm_sdcc: Handle error cases in probe
      mmc: msm_sdcc: Enable SDC host->clk only after setting the rate.
      msm: mmc: Remove "pio_irq" resource
      mmc: msm_sdcc: Use MCI_INT_MASK0 for PIO interrupts
      mmc: msm_sdcc: Change initialization order of busclk_timer in probe

Subhash Jadavani (1):
      mmc: msm_sdcc: Handle dma resource not present case

 arch/arm/mach-msm/devices-msm7x00.c  |   24 ----------
 arch/arm/mach-msm/devices-qsd8x50.c  |   24 ----------
 arch/arm/mach-msm/include/mach/mmc.h |    9 +----
 drivers/mmc/host/msm_sdcc.c          |   78 +++++++++++++++++++++++----------
 drivers/mmc/host/msm_sdcc.h          |    6 ++-
 5 files changed, 60 insertions(+), 81 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
