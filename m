Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2FJTKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 15:10:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41198 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2FJTKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 15:10:51 -0400
From: William Blair <wdblair@bu.edu>
To: acho@novell.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        William Blair <wdblair@bu.edu>
Subject: [PATCH] Staging: keucr: init: fixed a brace coding style issue
Date: Sun, 10 Jun 2012 15:10:33 -0400
Message-Id: <1339355433-7065-1-git-send-email-wdblair@bu.edu>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: William Blair <wdblair@bu.edu>
---
 drivers/staging/keucr/init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 071bdc2..231611d 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -30,9 +30,8 @@ int ENE_InitMedia(struct us_data *us)
 	if (MiscReg03 & 0x02) {
 		if (!us->SM_Status.Ready && !us->MS_Status.Ready) {
 			result = ENE_SMInit(us);
-			if (result != USB_STOR_XFER_GOOD) {
+			if (result != USB_STOR_XFER_GOOD)
 				return USB_STOR_TRANSPORT_ERROR;
-			}
 		}
 
 	}
-- 
1.7.6

