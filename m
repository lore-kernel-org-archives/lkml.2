Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2KGOo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:44:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47536 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab2KGOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:44:54 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 0/3] pwm: Drivers for twl4030/6030 PWMs and LEDs
Date: Wed, 7 Nov 2012 15:44:45 +0100
Message-ID: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The currently available pwm-twl6030.c driver only supports TWL6030's Charging
indication LED.
Remove this driver and add two new ones which implements support for all PWM
driven outputs:
pwm-twl driver supports twl4030 (PWM 0/1) and twl6030 (PWM 1/2) instances
pwm-twl-led driver supports twl4030 (PWM driven LED A/B ports) and twl6030's
Charging indication LED (PWM driven).

Regards,
Peter
---
Peter Ujfalusi (3):
  pwm: Remove pwm-twl6030 driver
  pwm: New driver to support PWMs on TWL4030/6030 series of PMICs
  pwm: New driver to support PWM driven LEDs on TWL4030/6030 series of
    PMICs

 drivers/pwm/Kconfig       |  19 ++-
 drivers/pwm/Makefile      |   3 +-
 drivers/pwm/pwm-twl-led.c | 287 +++++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/pwm-twl.c     | 304 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/pwm-twl6030.c | 184 ----------------------------
 5 files changed, 608 insertions(+), 189 deletions(-)
 create mode 100644 drivers/pwm/pwm-twl-led.c
 create mode 100644 drivers/pwm/pwm-twl.c
 delete mode 100644 drivers/pwm/pwm-twl6030.c

-- 
1.8.0

