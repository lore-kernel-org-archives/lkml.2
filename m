Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1HLXAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 19:00:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1120 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1HLXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 19:00:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6436"; a="109856845"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 0/4] Initial DT support for MSM8660
Date: Fri, 12 Aug 2011 16:00:04 -0700
Message-Id: <1313190008-7551-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds initial support for booting the MSM8660 via
devicetree.  The target boots with a serial console, and no platform
data.

In order to test this with a devicetree boot, it is necessary to
include patches allowing the devicetree to be appended to the kernel,
and merge ATAG values into the DT.

Once these patches reach mainline, I intend to remove the non-DT boot
for this target.

David Brown (4):
  msm_serial: Use relative resources for iomem
  msm_serial: Add devicetree support
  ARM: msm: Add devicetree support for msm8660-surf
  ARM: msm: Describe MSM 8660 SURF FPGA registers in DT

 .../devicetree/bindings/tty/serial/msm_serial.txt  |   18 ++++
 arch/arm/boot/dts/msm8660-surf.dts                 |   29 ++++++
 arch/arm/mach-msm/board-msm8x60.c                  |   98 ++++++++++++++++++--
 drivers/tty/serial/msm_serial.c                    |   30 ++++--
 4 files changed, 158 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
 create mode 100644 arch/arm/boot/dts/msm8660-surf.dts

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

