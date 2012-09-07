Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2IGEYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:24:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44035 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2IGEYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:24:31 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 07/57] staging/rts_pstor: remove braces {} in sd.c (sd_set_clock_divider)
Date: Fri,  7 Sep 2012 13:24:26 +0900
Message-Id: <1346991866-16608-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 4021295..1af5210 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -668,13 +668,12 @@ static int sd_set_clock_divider(struct rtsx_chip *chip, u8 clk_div)
 		val = clk_div;
 	} else {
 		mask = 0x60;
-		if (clk_div == SD_CLK_DIVIDE_0) {
+		if (clk_div == SD_CLK_DIVIDE_0)
 			val = 0x00;
-		} else if (clk_div == SD_CLK_DIVIDE_128) {
+		else if (clk_div == SD_CLK_DIVIDE_128)
 			val = 0x40;
-		} else if (clk_div == SD_CLK_DIVIDE_256) {
+		else if (clk_div == SD_CLK_DIVIDE_256)
 			val = 0x20;
-		}
 	}
 
 	RTSX_WRITE_REG(chip, REG_SD_CFG1, mask, val);
-- 
1.7.9.5

