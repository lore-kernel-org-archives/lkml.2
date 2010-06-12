Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0FLATh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 20:19:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43134 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0FLATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 20:19:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44210859"
From: Gregory Bean <gbean@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 0/2 v2] gpio: msm7200a: Add gpiolib support for MSM chips.
Date: Fri, 11 Jun 2010 17:19:27 -0700
Message-Id: <1276301969-31385-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

Here is a proposed driver which adds gpio and irq support to all 
currently-supported arm-msm SoCs. Feedback is greatly appreciated.

Revision history:
v2: Cleaned up some housekeeping noise in probe and remove methods.

Gregory Bean (2):
  gpio: msm7200a: Add gpiolib support for MSM chips.
  gpio: msm7200a: Add irq support to msm-gpiolib.

 MAINTAINERS                   |    2 +
 drivers/gpio/Kconfig          |    8 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/msm7200a-gpio.c  |  397 +++++++++++++++++++++++++++++++++++++++++
 include/linux/msm7200a-gpio.h |   51 ++++++
 5 files changed, 459 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/msm7200a-gpio.c
 create mode 100644 include/linux/msm7200a-gpio.h

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
