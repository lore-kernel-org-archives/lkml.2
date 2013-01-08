Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3AHJ6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:58:15 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:45641 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3AHJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:58:12 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r089vU23032613
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v4 2/8] MFD:rtsx: Remove redundant code
Date: Tue, 8 Jan 2013 17:57:23 +0800
Message-ID: <08bda2184701413431444c0e58219ace09c5d97b.1357638064.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357638064.git.wei_wang@realsil.com.cn>
References: <cover.1357638064.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

In function rtsx_pci_add_sg_tbl, the statement "ptr++" is useless.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 drivers/mfd/rtsx_pcr.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 3a44efa..fa2c2bc 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -325,7 +325,6 @@ static void rtsx_pci_add_sg_tbl(struct rtsx_pcr *pcr,
 	val = ((u64)addr << 32) | ((u64)len << 12) | option;
 
 	put_unaligned_le64(val, ptr);
-	ptr++;
 	pcr->sgi++;
 }
 
-- 
1.7.9.5

