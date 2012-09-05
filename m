Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2IEQck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:32:40 -0400
Received: from masquerade.micron.com ([137.201.242.130]:7979 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2IEQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:32:39 -0400
Message-ID: <50477E90.5070002@micron.com>
Date: Wed, 5 Sep 2012 22:02:16 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 3/6] mtip32xx: Increase timeout for standby command
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19164.003
X-TM-AS-Result: No-5.069600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increased timeout for standby command to work with larger capacity drives

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 2553c73..cf557a4 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2047,7 +2047,7 @@ static void mtip_set_timeout(struct host_to_dev_fis *fis, unsigned int *timeout)
 		*timeout = 240000; /* 4 minutes */
 		break;
 	case ATA_CMD_STANDBYNOW1:
-		*timeout = 10000;  /* 10 seconds */
+		*timeout = 120000;  /* 2 minutes */
 		break;
 	case 0xF7:
 	case 0xFA:
-- 
1.7.1

