Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1EPGtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:49:14 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47383 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1EPGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pFm1svjv0JVh98MU4HHZe9Br/JgNsBhos0/g7g0fiWLG5T5KabzZ/7nMENXCxt0Wrj
         R6f7qhQr5gIkKL/GQSNjizkaXltwQwX6ApG7ltxhCtSghgxvbi/QFuiR99OuWQCJxzxD
         +ODUq+vuD7W6RKW8/m5ULhcmXqKJEMiA+LXDo=
From: Weiping Pan <panweiping3@gmail.com>
Cc: Weiping Pan <panweiping3@gmail.com>,
        Mattia Dongili <malattia@linux.it> (maintainer:SONY VAIO CONTROL...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        platform-driver-x86@vger.kernel.org (open list:SONY VAIO CONTROL...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] platform/x86:delete two unused variables
Date: Mon, 16 May 2011 14:49:47 +0800
Message-Id: <1305528587-19686-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

variable handle is not used in these two functions,
just delete them.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/platform/x86/sony-laptop.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 6fe8cd6..9a2c319 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -961,7 +961,6 @@ static int sony_backlight_get_brightness(struct backlight_device *bd)
 static int sony_nc_get_brightness_ng(struct backlight_device *bd)
 {
 	int result;
-	int *handle = (int *)bl_get_data(bd);
 	struct sony_backlight_props *sdev =
 		(struct sony_backlight_props *)bl_get_data(bd);
 
@@ -973,7 +972,6 @@ static int sony_nc_get_brightness_ng(struct backlight_device *bd)
 static int sony_nc_update_status_ng(struct backlight_device *bd)
 {
 	int value, result;
-	int *handle = (int *)bl_get_data(bd);
 	struct sony_backlight_props *sdev =
 		(struct sony_backlight_props *)bl_get_data(bd);
 
-- 
1.7.4.4

