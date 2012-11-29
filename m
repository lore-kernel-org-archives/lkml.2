Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2K2LVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:21:22 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50914 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2K2LVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:21:20 -0500
From: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        "Laurent Navet [Mali]" <laurent.navet@gmail.com>
Subject: [PATCH] staging: line6: Fix checkpatch.pl switch - case issue
Date: Thu, 29 Nov 2012 12:21:22 +0100
Message-Id: <1354188082-2655-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Laurent Navet [Mali]" <laurent.navet@gmail.com>

delete old commentted code to avoid this checkpatch error :
 line6/pcm.c:423: ERROR: switch and case should be at the same indent

Signed-off-by: Laurent Navet [Mali] <laurent.navet@gmail.com>
---
 drivers/staging/line6/pcm.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 6c1e313..a0ce781 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -455,14 +455,6 @@ int line6_init_pcm(struct usb_line6 *line6,
 		ep_write = 0x01;
 		break;
 
-		/* this is for interface_number == 1:
-		   case LINE6_DEVID_TONEPORT_UX2:
-		   case LINE6_DEVID_PODSTUDIO_UX2:
-		   ep_read  = 0x87;
-		   ep_write = 0x00;
-		   break;
-		 */
-
 	default:
 		MISSING_CASE;
 	}
-- 
1.7.10.4

