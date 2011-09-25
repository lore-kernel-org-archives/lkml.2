Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1IYCMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 22:12:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38170 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1IYCMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 22:12:45 -0400
Subject: [PATCH] backlight: Rename corgibl_limit_intensity to
 genericbl_limit_intensity
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Sep 2011 10:12:33 +0800
Message-ID: <1316916753.5006.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rename of corgibl_limit_intensity is missed in commit d00ba726
"backlight: Rename the corgi backlight driver to generic".
Let's fix it now.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/generic_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 8c6befd..adb1914 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -56,7 +56,7 @@ static int genericbl_get_intensity(struct backlight_device *bd)
  * Called when the battery is low to limit the backlight intensity.
  * If limit==0 clear any limit, otherwise limit the intensity
  */
-void corgibl_limit_intensity(int limit)
+void genericbl_limit_intensity(int limit)
 {
 	struct backlight_device *bd = generic_backlight_device;
 
@@ -68,7 +68,7 @@ void corgibl_limit_intensity(int limit)
 	backlight_update_status(generic_backlight_device);
 	mutex_unlock(&bd->ops_lock);
 }
-EXPORT_SYMBOL(corgibl_limit_intensity);
+EXPORT_SYMBOL(genericbl_limit_intensity);
 
 static const struct backlight_ops genericbl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
-- 
1.7.4.1



