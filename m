Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2BSPMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 10:12:08 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:46541 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2BSPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 10:12:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 4/5] input: s/#if CONFIG/#ifdef CONFIG/
Date: Sun, 19 Feb 2012 16:11:58 +0100
Message-Id: <1329664319-3128-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k:

drivers/input/misc/twl4030-vibra.c:175:5: warning: "CONFIG_PM" is not defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/misc/twl4030-vibra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 3765137..2739f32 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -172,7 +172,7 @@ static void twl4030_vibra_close(struct input_dev *input)
 }
 
 /*** Module ***/
-#if CONFIG_PM
+#ifdef CONFIG_PM
 static int twl4030_vibra_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-- 
1.7.0.4

