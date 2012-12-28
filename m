Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2L1Clz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 21:41:55 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47837 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2L1Clw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 21:41:52 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qBS2f8wt002275, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3 0/8] rtsx patchset for MFD and MMC tree
Date: Fri, 28 Dec 2012 10:41:07 +0800
Message-ID: <cover.1356662293.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Wei WANG (8):
  MFD:rtsx: Fix typo in comment
  MFD:rtsx: Remove redundant code
  MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
  MFD:rtsx: Add callback function switch_output_voltage
  MMC:rtsx: Using callback function to switch output voltage
  MFD:rtsx: Add callback function conv_clk_and_div_n
  MFD:rtsx: Fix checkpatch warning
  MFD:rtsx: Use macro defines to replace some variables

 drivers/mfd/rtl8411.c             |   29 ++++++++++++++++++++++++
 drivers/mfd/rts5209.c             |   21 +++++++++++++++++
 drivers/mfd/rts5229.c             |   21 +++++++++++++++++
 drivers/mfd/rtsx_pcr.c            |   45 +++++++++++++++++++++++++------------
 drivers/mfd/rtsx_pcr.h            |    3 +++
 drivers/mmc/host/rtsx_pci_sdmmc.c |   30 +++++--------------------
 include/linux/mfd/rtsx_common.h   |    3 +++
 include/linux/mfd/rtsx_pci.h      |   27 +++++++++++++++++-----
 8 files changed, 135 insertions(+), 44 deletions(-)

-- 
1.7.9.5

