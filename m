Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2LXGES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 01:04:18 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50310 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2LXGD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 01:03:58 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qBO63E3c029274, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 0/7] rtsx patchset for MFD and MMC tree
Date: Mon, 24 Dec 2012 14:03:07 +0800
Message-ID: <cover.1356319097.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Wei WANG (7):
  MFD:rtsx: Fix typo in comment
  MFD:rtsx: Remove redundant code
  MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
  MFD:rtsx: Add callback function switch_output_voltage
  MMC:rtsx: Using callback function to switch output voltage
  MFD:rtsx: Add callback function conv_clk_and_div_n
  MFD:rtsx: Fix checkpatch warning

 drivers/mfd/rtl8411.c             |   29 ++++++++++++++++++++++++
 drivers/mfd/rts5209.c             |   21 ++++++++++++++++++
 drivers/mfd/rts5229.c             |   21 ++++++++++++++++++
 drivers/mfd/rtsx_pcr.c            |   44 +++++++++++++++++++++++++++----------
 drivers/mmc/host/rtsx_pci_sdmmc.c |   30 +++++--------------------
 include/linux/mfd/rtsx_common.h   |    3 +++
 include/linux/mfd/rtsx_pci.h      |   27 ++++++++++++++++++-----
 7 files changed, 134 insertions(+), 41 deletions(-)

-- 
1.7.9.5

