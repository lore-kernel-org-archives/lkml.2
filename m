Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0FPCnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 22:43:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29149 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab0FPCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 22:43:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6014"; a="44430701"
From: Gregory Bean <gbean@codeaurora.org>
To: davidb@codeaurora.org, dwalker@codeaurora.org, bryanh@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 0/2] arm: msm: Add gpiolib support for MSM7200A-family chips.
Date: Tue, 15 Jun 2010 19:43:46 -0700
Message-Id: <1276656228-9376-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

Here is a proposed driver which adds gpio and irq support to all
currently-supported arm-msm SoCs. Feedback is greatly appreciated.
This is the second submission after it was decided that this code belongs
in mach-msm instead of the generic drivers/gpio.  It did receive some
reviewing while submitted there.  For completeness, I include those
notes here as well:

First-submission revision history:
v2: Cleaned up some housekeeping noise in probe and remove methods.
v3: Incorporated feedback from ben-linux@fluff.org.
v4: Incorporated feedback from akpm@linux-foundation.org.
v5: Incorporated feedback from vapier.adi@gmail.com, moved code
    for resubmission.

Gregory Bean (2):
  arm: msm: Add gpiolib support for MSM7200A-family chips.
  arm: msm: Add irq support to msm7200a-gpio.

 arch/arm/mach-msm/Kconfig         |    7 +
 arch/arm/mach-msm/Makefile        |    2 +-
 arch/arm/mach-msm/msm7200a-gpio.c |  353 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/msm7200a-gpio.h |   87 +++++++++
 4 files changed, 448 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-msm/msm7200a-gpio.c
 create mode 100644 arch/arm/mach-msm/msm7200a-gpio.h

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
