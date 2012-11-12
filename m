Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2KLOlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:41:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45577 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2KLOla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:41:30 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 0/3] leds: leds-pwm: Device tree support
Date: Mon, 12 Nov 2012 15:41:07 +0100
Message-ID: <1352731270-27534-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The patch:
https://lkml.org/lkml/2012/11/7/187
grown to be a series to add DeviceTree support for the leds-pwm driver.

Changes since v1:
- As suggested by Bryan Wu: the legacy pwm_request() has been removed from
  patch 1
- Device tree bindings added for leds-pwm driver.

When we boot with Device tree we handle one LED per device to be more aligned
with PWM core's DT implementation.
An example of the DT usage is provided in the new DT binding documentation for
leds-pwm.

Tested on OMAP4 Blaze (SDP) with legacy and DT boot.

Regards,
Peter
---
Peter Ujfalusi (3):
  leds: leds-pwm: Convert to use devm_get_pwm
  leds: leds-pwm: Preparing the driver for device tree support
  leds: leds-pwm: Add device tree bindings

 .../devicetree/bindings/leds/leds-pwm.txt          |  34 +++++
 drivers/leds/leds-pwm.c                            | 161 ++++++++++++++-------
 include/linux/leds_pwm.h                           |   2 +-
 3 files changed, 146 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt

-- 
1.8.0

