Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585Ab0FKT7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:59:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29703 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760542Ab0FKT7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:59:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6010"; a="44053612"
From: Gregory Bean <gbean@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 0/2] Add gpiolib support for MSM chips.
Date: Fri, 11 Jun 2010 12:58:50 -0700
Message-Id: <1276286332-13515-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

Here is a proposed driver which adds gpio and irq support to all 
currently-supported arm-msm SoCs. Feedback is greatly appreciated.

Gregory Bean (2):
  gpio: msm7200a: Add gpiolib support for MSM chips.
  gpio: msm7200a: Add irq support to msm-gpiolib.

 MAINTAINERS                   |    2 +
 drivers/gpio/Kconfig          |    8 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/msm7200a-gpio.c  |  398 +++++++++++++++++++++++++++++++++++++++++
 include/linux/msm7200a-gpio.h |   51 ++++++
 5 files changed, 460 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/msm7200a-gpio.c
 create mode 100644 include/linux/msm7200a-gpio.h

---
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
