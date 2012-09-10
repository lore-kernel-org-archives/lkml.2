Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2IJIEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:04:15 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38826 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2IJIEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:04:11 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q8A83LZw007310, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v5 0/3] Add modules to support realtek PCIE card reader
Date: Mon, 10 Sep 2012 16:03:21 +0800
Message-ID: <cover.1347256563.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Support for Realtek PCI-Express driver-based card readers including rts5209 and rts5229.

v2:
1. Using platform device to replace realtek slot bus

v3:
1. Fix a bug that DMA out of SW-IOMMU space in Lenovo Thinkpad x121e
2. Tested by Borislav Petkov <bp@alien8.de>

v4:
1. Fulfill power management callbacks

v5:
1. Support Memstick card

Wei WANG (3):
  drivers/mfd: Add realtek pcie card reader driver
  drivers/mmc: Add realtek pcie sdmmc host driver
  drivers/memstick: Add realtek pcie memstick host driver

 drivers/memstick/host/Kconfig       |   10 +
 drivers/memstick/host/Makefile      |    1 +
 drivers/memstick/host/rtsx_pci_ms.c |  637 ++++++++++++++++
 drivers/mfd/Kconfig                 |    9 +
 drivers/mfd/Makefile                |    4 +
 drivers/mfd/rts5209.c               |  223 ++++++
 drivers/mfd/rts5229.c               |  215 ++++++
 drivers/mfd/rtsx_pcr.c              | 1359 ++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.h              |   31 +
 drivers/mmc/host/Kconfig            |    7 +
 drivers/mmc/host/Makefile           |    2 +
 drivers/mmc/host/rtsx_pci_sdmmc.c   | 1372 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/rtsx_common.h     |   47 ++
 include/linux/mfd/rtsx_pci.h        |  765 +++++++++++++++++++
 14 files changed, 4682 insertions(+)
 create mode 100644 drivers/memstick/host/rtsx_pci_ms.c
 create mode 100644 drivers/mfd/rts5209.c
 create mode 100644 drivers/mfd/rts5229.c
 create mode 100644 drivers/mfd/rtsx_pcr.c
 create mode 100644 drivers/mfd/rtsx_pcr.h
 create mode 100644 drivers/mmc/host/rtsx_pci_sdmmc.c
 create mode 100644 include/linux/mfd/rtsx_common.h
 create mode 100644 include/linux/mfd/rtsx_pci.h

-- 
1.7.9.5

