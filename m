Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2KGMeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:34:13 -0500
Received: from masquerade.micron.com ([137.201.242.130]:1158 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2KGMeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:34:12 -0500
Message-ID: <509A5C3C.6080107@micron.com>
Date: Wed, 7 Nov 2012 06:03:56 -0700
From: Selvan Mani <smani@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <sbradshaw@micron.com>, <asamymuthupa@micron.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] mtip32xx: Fix incorrect mask used for erase mode
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19346.007
X-TM-AS-Result: No--2.417800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previous commit use value 3 for erasemode mask.
Changing the mask to correct value to 2

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 5f4a917..8498e99 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -34,7 +34,7 @@
 #define PCIE_CONFIG_EXT_DEVICE_CONTROL_OFFSET	0x48
 
 /* check for erase mode support during secure erase */
-#define MTIP_SEC_ERASE_MODE     0x3
+#define MTIP_SEC_ERASE_MODE     0x2
 
 /* # of times to retry timed out/failed IOs */
 #define MTIP_MAX_RETRIES	2
-- 
1.7.1
