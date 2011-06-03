Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1FCC1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:27:42 -0400
Received: from mta31.charter.net ([216.33.127.82]:43517 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1FCC1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:27:41 -0400
X-Greylist: delayed 940 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jun 2011 22:27:40 EDT
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=GGrxyAfQCZYA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=rxttENXTW1sgyJ2bJW0A:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: malattia@linux.it
Cc: mjg@redhat.com, kernel-janitors@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] sony-laptop: remove unused local variables
Date: Thu,  2 Jun 2011 21:27:20 -0500
Message-Id: <1307068040-2918-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed two unused instances of "handle" local variable.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
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
1.7.2.5

