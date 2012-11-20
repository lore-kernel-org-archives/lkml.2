Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2KTCJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:09:51 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50354 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2KTCJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:09:49 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qAK29DvL022331, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2 0/2] rtsx patch for for-next branch in MFD tree
Date: Tue, 20 Nov 2012 10:09:12 +0800
Message-ID: <cover.1353377266.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Wei WANG (2):
  mmc/host/rtsx: Configure SD_CFG2 register in sd_rw_multi
  mmc/host/rtsx: Explicitely include slab.h in rtsx_pci_sdmmc.c

 drivers/mmc/host/rtsx_pci_sdmmc.c |    2 ++
 1 file changed, 2 insertions(+)

-- 
1.7.9.5

