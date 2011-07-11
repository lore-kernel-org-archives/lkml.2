Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1GKGcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 02:32:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56983 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab1GKGco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 02:32:44 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 6/6] Staging: comedi: fix brace coding style issue in pcl818.c
Date: Mon, 11 Jul 2011 12:15:21 +0530
Message-Id: <1310366721-22097-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi:fix brace coding style issue in pcl818.c>
References: <[PATCH]Staging: comedi:fix brace coding style issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a brace warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 241b16b..86b30c3 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1301,10 +1301,9 @@ static void setup_channel_list(struct comedi_device *dev,
 */
 static int check_single_ended(unsigned int port)
 {
-	if (inb (port + PCL818_STATUS) & 0x20)
+	if (inb(port + PCL818_STATUS) & 0x20)
 		return 1;
-	else
-		return 0;
+	return 0;
 }
 
 /*
-- 
1.6.5.2

