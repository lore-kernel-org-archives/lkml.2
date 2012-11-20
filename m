Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2KTBNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:13:15 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:48316 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:13:10 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qAK1COhv011369, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 0/2] rtsx patch for for-next branch in MFD tree
Date: Tue, 20 Nov 2012 09:12:24 +0800
Message-ID: <cover.1353373737.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Wei WANG (2):
  mmc: Configure SD_CFG2 register in sd_rw_multi
  mmc: Explicitely include slab.h in rtsx_pci_sdmmc.c

 drivers/mmc/host/rtsx_pci_sdmmc.c |    2 ++
 1 file changed, 2 insertions(+)

-- 
1.7.9.5

