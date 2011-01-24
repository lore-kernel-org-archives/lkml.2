Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1AXXmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:42:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4722 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1AXXmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:42:22 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71821650"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL for 38-rc3] msm: sdcc driver fixes
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110124:torvalds@linux-foundation.org::MMwfqu5tiYHBlemH:000000000000000000000000000000005MDh
X-Hashcash: 1:20:110124:linux-arm-msm@vger.kernel.org::nyXHCxWKqECLXBQV:000000000000000000000000000000003kM4
X-Hashcash: 1:20:110124:linux-kernel@vger.kernel.org::Ra4Vzvy1sl4ApA2d:0000000000000000000000000000000001o9B
X-Hashcash: 1:20:110124:linux-arm-kernel@lists.infradead.org::xxllu0c6kXWy1RrR:00000000000000000000000003JAY
Date: Mon, 24 Jan 2011 15:42:21 -0800
Message-ID: <8yatygxj2ci.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix some problems with the MMC/SD driver for MSM
chips.  The first fixes a compilation error.  The driver was using
internal DMA apis, this fix changes it to use the proper APIs.  The
second patch fixes a clock enable/disable mismatch.

Thanks,
David Brown

The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:

  Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git for-38-rc3

Daniel Walker (2):
      mmc: msm: fix dma usage not to use internal APIs
      drivers: mmc: msm: remove clock disable in probe

 drivers/mmc/host/msm_sdcc.c |   52 ++++++++++++++++++------------------------
 1 files changed, 22 insertions(+), 30 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
