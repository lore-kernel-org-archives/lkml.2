Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0CWC3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:29:53 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:36289 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0CWC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CzMus8q12QPdjO1jvPVfhQAgL5kiKhqGx9pgVBQood6JgYwx8CcG+vKGrind8OcatJ
         bIRgHyMSBeae2/Fy8Di9NBWqKqwrTbjW+0egS/tsuVQ4E/je61HXpCfzqzB3TABtKlxb
         b5eYcRSHvz/WajGBbJ17NvsnxN8Wv8wKHJqNc=
From: sai <tsg321@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sai <tsg321@gmail.com>
Subject: [PATCH] staging:cx2581: fixes coding style issues in cx25821-cards.c
Date: Tue, 23 Mar 2010 07:59:25 +0530
Message-Id: <1269311365-2579-1-git-send-email-tsg321@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sai <tsg321@gmail.com>

This patch fixes all the coding style issues reported by checkpatch.pl tool
Signed-off-by: sai<tsg321@gmail.com>
---
 drivers/staging/cx25821/cx25821-cards.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/staging/cx25821/cx25821-cards.c
index 4d0b9ea..da0f56d 100644
--- a/drivers/staging/cx25821/cx25821-cards.c
+++ b/drivers/staging/cx25821/cx25821-cards.c
@@ -30,12 +30,12 @@
 #include "cx25821.h"
 #include "tuner-xc2028.h"
 
-// board config info
+/* board config info */
 
 struct cx25821_board cx25821_boards[] = {
 	[UNKNOWN_BOARD] = {
 			   .name = "UNKNOWN/GENERIC",
-			   // Ensure safe default for unknown boards
+			   /* Ensure safe default for unknown boards */
 			   .clk_freq = 0,
 			   },
 
-- 
1.6.3.3

