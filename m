Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2ABMx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:53:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59084 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2ABMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:53:24 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, robherring2@gmail.com,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv3 0/3] Synopsys DesignWare GPIO support
Date: Mon,  2 Jan 2012 12:53:15 +0000
Message-Id: <1325508798-25439-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pretty much the same as last time with the exception that I've split the
IRQ portion from the GPIO bit and added a dependency on IRQ_DOMAIN
rather than selecting it.

The 2nd patch is dependent on Rob's irqdomain support for the generic
irq chip so can be dropped if needed.

Jamie Iles (3):
  gpio: add a driver for the Synopsys DesignWare APB GPIO block
  gpio: dwapb: add support for GPIO interrupts
  ARM: picoxcell: use new Synopsys Designware GPIO binding

 .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   63 ++++
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |   19 +-
 arch/arm/boot/dts/picoxcell-pc3x3.dtsi             |   28 +-
 drivers/gpio/Kconfig                               |    9 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-dwapb.c                          |  351 ++++++++++++++++++++
 6 files changed, 443 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
 create mode 100644 drivers/gpio/gpio-dwapb.c

-- 
1.7.5.4

