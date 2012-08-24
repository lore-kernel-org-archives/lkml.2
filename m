Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2HXKBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:01:04 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55780 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2HXKBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:01:03 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q7OA0PnF000905, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <bp@alien8.de>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v4 0/2] Add modules to support realtek PCIE card reader
Date: Fri, 24 Aug 2012 18:00:25 +0800
Message-ID: <cover.1345801051.git.wei_wang@realsil.com.cn>
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

Wei WANG (2):
  drivers/mfd: Add realtek pcie card reader driver
  drivers/mmc: Add realtek pcie sdmmc host driver

 drivers/mfd/Kconfig               |    9 +
 drivers/mfd/Makefile              |    4 +
 drivers/mfd/rts5209.c             |  104 +++
 drivers/mfd/rts5229.c             |  119 ++++
 drivers/mfd/rtsx_pcr.c            | 1321 +++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.h            |   31 +
 drivers/mmc/host/Kconfig          |    7 +
 drivers/mmc/host/Makefile         |    2 +
 drivers/mmc/host/rtsx_pci_sdmmc.c | 1378 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/rtsx_common.h   |   47 ++
 include/linux/mfd/rtsx_pci.h      |  690 +++++++++++++++++++
 11 files changed, 3712 insertions(+)
 create mode 100644 drivers/mfd/rts5209.c
 create mode 100644 drivers/mfd/rts5229.c
 create mode 100644 drivers/mfd/rtsx_pcr.c
 create mode 100644 drivers/mfd/rtsx_pcr.h
 create mode 100644 drivers/mmc/host/rtsx_pci_sdmmc.c
 create mode 100644 include/linux/mfd/rtsx_common.h
 create mode 100644 include/linux/mfd/rtsx_pci.h

-- 
1.7.9.5

