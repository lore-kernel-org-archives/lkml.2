Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0FWUil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:38:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0FWUij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:38:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6022"; a="45321633"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 0/3 v3] msm: Add gpiolib devices to MSM7x30 and QSD8x50.
Date: Wed, 23 Jun 2010 13:38:33 -0700
Message-Id: <1277325516-24111-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

Here is a proposed patch series which adds the configuration and devices
needed to enable gpiolib on the MSM7x30 and QSD8x50 chipsets.

Thanks,

G

Gregory Bean (3):
  msm: Add gpio register address mapping information.
  msm: 7x30: Add gpio device configuration.
  msm: 8x50: add gpio device configuration.

 arch/arm/mach-msm/board-msm7x30.c     |   27 ++++++++-
 arch/arm/mach-msm/board-qsd8x50.c     |   27 ++++++++-
 arch/arm/mach-msm/devices-msm7x30.c   |   21 +++++++
 arch/arm/mach-msm/devices-qsd8x50.c   |   21 +++++++
 arch/arm/mach-msm/devices.h           |   33 +++++++++++
 arch/arm/mach-msm/gpio_hw-7x30.h      |  100 +++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/gpio_hw-7xxx.h      |   84 +++++++++++++++++++++++++++
 arch/arm/mach-msm/gpio_hw-8x50.h      |  100 +++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/gpio_hw.h           |   35 +++++++++++
 arch/arm/mach-msm/include/mach/gpio.h |    2 +
 10 files changed, 446 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-msm/gpio_hw-7x30.h
 create mode 100644 arch/arm/mach-msm/gpio_hw-7xxx.h
 create mode 100644 arch/arm/mach-msm/gpio_hw-8x50.h
 create mode 100644 arch/arm/mach-msm/gpio_hw.h

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
