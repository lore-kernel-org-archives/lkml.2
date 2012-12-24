Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2LXGEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 01:04:00 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50311 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2LXGD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 01:03:58 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qBO63JWC029299, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 1/7] MFD:rtsx: Fix typo in comment
Date: Mon, 24 Dec 2012 14:03:19 +0800
Message-ID: <96e414124cedf14c9783acbf6579f6ce357da2d1.1356319097.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1356319097.git.wei_wang@realsil.com.cn>
References: <cover.1356319097.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Fix a misspelling word in comment

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 include/linux/mfd/rtsx_pci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 060b721..bebe9f9 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -452,7 +452,7 @@
 #define	SD_RSP_TYPE_R6			0x01
 #define	SD_RSP_TYPE_R7			0x01
 
-/* SD_CONFIURE3 */
+/* SD_CONFIGURE3 */
 #define	SD_RSP_80CLK_TIMEOUT_EN		0x01
 
 /* Card Transfer Reset Register */
-- 
1.7.9.5

