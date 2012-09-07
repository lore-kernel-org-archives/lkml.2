Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab2IGEeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:34:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2IGEed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:34:33 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 36/57] staging/rts_pstor: remove braces {} in sd.c (sd_read_lba0)
Date: Fri,  7 Sep 2012 13:34:28 +0900
Message-Id: <1346992469-17544-1-git-send-email-yamanetoshi@gmail.com>
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
index 7be3805..7318349 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2126,13 +2126,12 @@ static int sd_read_lba0(struct rtsx_chip *chip)
 	if (CHK_SD(sd_card)) {
 		bus_width = SD_BUS_WIDTH_4;
 	} else {
-		if (CHK_MMC_8BIT(sd_card)) {
+		if (CHK_MMC_8BIT(sd_card))
 			bus_width = SD_BUS_WIDTH_8;
-		} else if (CHK_MMC_4BIT(sd_card)) {
+		else if (CHK_MMC_4BIT(sd_card))
 			bus_width = SD_BUS_WIDTH_4;
-		} else {
+		else
 			bus_width = SD_BUS_WIDTH_1;
-		}
 	}
 
 	retval = sd_read_data(chip, SD_TM_NORMAL_READ, cmd,
-- 
1.7.9.5

