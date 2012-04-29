Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2D2Osr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:48:47 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:47715 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751694Ab2D2Ork (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:47:40 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v8 0/5] USB: LPC32xx device tree related OHCI and UDC patch series
Date: Sun, 29 Apr 2012 16:47:01 +0200
Message-Id: <1335710826-6684-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series collects the pending LPC32xx patches in one series and forward
ports it onto

git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-next

There are no other changes since last post.

Roland Stigge (5):
  ohci-nxp: Driver cleanup
  ohci-nxp: Device tree support
  USB: Add driver for NXP ISP1301 USB transceiver
  USB: gadget driver for LPC32xx
  USB: ohci-nxp: Use isp1301 driver

 Documentation/devicetree/bindings/usb/isp1301.txt  |   25 +
 .../devicetree/bindings/usb/lpc32xx-udc.txt        |   28 +
 Documentation/devicetree/bindings/usb/ohci-nxp.txt |   24 +
 drivers/usb/Kconfig                                |    2 +
 drivers/usb/Makefile                               |    1 +
 drivers/usb/gadget/Kconfig                         |   11 +
 drivers/usb/gadget/Makefile                        |    1 +
 drivers/usb/gadget/gadget_chips.h                  |    3 +
 drivers/usb/gadget/lpc32xx_udc.c                   | 3538 ++++++++++++++++++++
 drivers/usb/host/Kconfig                           |    1 +
 drivers/usb/host/ohci-nxp.c                        |  165 +-
 drivers/usb/phy/Kconfig                            |   17 +
 drivers/usb/phy/Makefile                           |    7 +
 drivers/usb/phy/isp1301.c                          |   77 +
 include/linux/usb/isp1301.h                        |   80 +
 15 files changed, 3861 insertions(+), 119 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/isp1301.txt
 create mode 100644 Documentation/devicetree/bindings/usb/lpc32xx-udc.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-nxp.txt
 create mode 100644 drivers/usb/gadget/lpc32xx_udc.c
 create mode 100644 drivers/usb/phy/Kconfig
 create mode 100644 drivers/usb/phy/Makefile
 create mode 100644 drivers/usb/phy/isp1301.c
 create mode 100644 include/linux/usb/isp1301.h

-- 
1.7.9

