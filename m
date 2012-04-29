Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2D2O5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:57:12 -0400
Received: from antcom.de ([188.40.178.216]:50263 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab2D2O5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:57:11 -0400
Message-ID: <4F9D56C2.2050307@antcom.de>
Date: Sun, 29 Apr 2012 16:57:06 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Subject: [GIT PULL] USB: LPC32xx device tree related OHCI and UDC patch series
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the pull request for the just re-posted series of LPC32xx related
USB patches (just ported onto current usb.git's usb-next).

Thanks in advance,

Roland


The following changes since commit 4212cd74ca6f0c42f5a0065797dd1c310a485ad8:

  USB: usb-skeleton.c: remove err() usage (2012-04-27 11:24:45 -0700)

are available in the git repository at:

  git://git.antcom.de/linux-2.6.git ohci-nxp

for you to fetch changes up to 5fc7346be73e695bb976d7bea2a421f1c443fa6c:

  USB: ohci-nxp: Use isp1301 driver (2012-04-29 15:27:20 +0200)

----------------------------------------------------------------
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
