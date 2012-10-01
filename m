Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2JALBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 07:01:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37297 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab2JALBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 07:01:39 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <sourav.poddar@ti.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <santosh.shilimkar@ti.com>
Subject: [PATCHv3 0/4] Add mfd driver for smsc-ece1099 chip
Date: Mon, 1 Oct 2012 16:30:57 +0530
Message-ID: <1349089257-22076-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a smsc-ece1099 mfd driver which will work as
keypad scan device or a gpio expander device.

Patch 1 creates the parent mfd driver.
Patch 2 add keypad support. Patch 3 adds dts
support for keypad in omap5 dts file.
Patch 4 add gpio expansion driver for chip (RFC).

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>

G, Manjunath Kondaiah (1):
  Input: keypad: Add smsc ece1099 keypad driver

Sourav Poddar (3):
  mfd: smsc: Add support for smsc gpio io/keypad driver
  arm/dts: omap5-evm: Add keypad support
  gpio: smscece: Add support for gpio IO expander feature

 Documentation/smsc_ece1099.txt               |   56 ++++
 arch/arm/boot/dts/omap5-evm.dts              |   95 +++++++
 drivers/gpio/Kconfig                         |    7 +
 drivers/gpio/Makefile                        |    1 +
 drivers/gpio/gpio-smscece.c                  |  381 ++++++++++++++++++++++++++
 drivers/input/keyboard/Kconfig               |   11 +
 drivers/input/keyboard/Makefile              |    1 +
 drivers/input/keyboard/smsc-ece1099-keypad.c |  304 ++++++++++++++++++++
 drivers/mfd/Kconfig                          |   12 +
 drivers/mfd/Makefile                         |    1 +
 drivers/mfd/smsc-ece1099.c                   |  113 ++++++++
 include/linux/mfd/smsc.h                     |  109 ++++++++
 12 files changed, 1091 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/smsc_ece1099.txt
 create mode 100644 drivers/gpio/gpio-smscece.c
 create mode 100644 drivers/input/keyboard/smsc-ece1099-keypad.c
 create mode 100644 drivers/mfd/smsc-ece1099.c
 create mode 100644 include/linux/mfd/smsc.h

