Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0GIWuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:50:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48653 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0GIWuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:50:02 -0400
From: Rene Sapiens <rene.sapiens@ti.com>
To: greg@kroah.com
Cc: gregkh@suse.de, andy.shevchenko@gmail.com, omar.ramirez@ti.com,
       ohad@wizery.com, ameya.palande@nokia.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Rene Sapiens <rene.sapiens@ti.com>
Subject: [PATCH] staging: ti dspbridge: fix compilation error
Date: Fri,  9 Jul 2010 17:48:52 -0500
Message-Id: <1278715732-21167-1-git-send-email-rene.sapiens@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a compilation error in uuid_hex_to_bin
due to the patch "simplify and clean up"

Signed-off-by: Rene Sapiens <rene.sapiens@ti.com>
---
 drivers/staging/tidspbridge/gen/uuidutil.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 drivers/staging/tidspbridge/gen/uuidutil.c

diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
index eb09bc3..070761b
--- a/drivers/staging/tidspbridge/gen/uuidutil.c
+++ b/drivers/staging/tidspbridge/gen/uuidutil.c
@@ -58,6 +58,7 @@ static s32 uuid_hex_to_bin(char *buf, s32 len)
 {
 	s32 i;
 	s32 result = 0;
+	int value;
 
 	for (i = 0; i < len; i++) {
 		value = hex_to_bin(*buf++);
-- 
1.6.3.3

