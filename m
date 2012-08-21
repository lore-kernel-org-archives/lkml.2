Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2HUFup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 01:50:45 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60806 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2HUFum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 01:50:42 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q7L5o1Ig005597, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@linuxfoundation.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <arnd@arndb.de>, <sameo@linux.intel.com>
CC: <bp@alien8.de>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3 0/2] Add modules to support realtek PCIE card reader
Date: Tue, 21 Aug 2012 13:50:01 +0800
Message-ID: <cover.1345516106.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

1. Fix a bug that DMA out of SW-IOMMU space in Lenovo Thinkpad x121e
2. Tested by Borislav Petkov <bp@alien8.de>

Wei WANG (2):
  drivers/mfd: Add realtek pcie card reader driver
  drivers/mmc: Add realtek pcie sdmmc host driver

 drivers/mfd/Kconfig               |    9 +
 drivers/mfd/Makefile              |    4 +
 drivers/mfd/rts5209.c             |  104 +++
 drivers/mfd/rts5229.c             |  119 ++++
 drivers/mfd/rtsx_pcr.c            | 1286 +++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.h            |   31 +
 drivers/mmc/host/Kconfig          |    7 +
 drivers/mmc/host/Makefile         |    2 +
 drivers/mmc/host/rtsx_pci_sdmmc.c | 1341 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/rtsx_common.h   |   47 ++
 include/linux/mfd/rtsx_pci.h      |  690 +++++++++++++++++++
 11 files changed, 3640 insertions(+)
 create mode 100644 drivers/mfd/rts5209.c
 create mode 100644 drivers/mfd/rts5229.c
 create mode 100644 drivers/mfd/rtsx_pcr.c
 create mode 100644 drivers/mfd/rtsx_pcr.h
 create mode 100644 drivers/mmc/host/rtsx_pci_sdmmc.c
 create mode 100644 include/linux/mfd/rtsx_common.h
 create mode 100644 include/linux/mfd/rtsx_pci.h

-- 
1.7.9.5

