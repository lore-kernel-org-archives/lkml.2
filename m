Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2ITKup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:50:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49865 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2ITKuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:50:44 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arun Murthy <arun.murthy@stericsson.com>,
        Matthew Garrett <mjg@redhat.com>, Robert Morell <rmorell@nvidia.com>,
        Dilan Lee <dilee@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH] pwm-backlight: Take over maintenance
Date: Thu, 20 Sep 2012 12:50:35 +0200
Message-Id: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:Mz93vq/CV6DzW40Xb5z10vCsGxIOT1VAmleOlDXuGw1
 KJ97a39P/riPed/w8NJBxlPG1wmALk1UTdXjR624dj+c84YEGz
 5XLMef00p4UfkKn84RfW5cl4ikLBBYopKr5r5cUSJJn5rVHe8y
 FDo8Objlw2x9cpPbEETRTEXy9mUgb+Dlbz5a6t5KsSKT5QuQhX
 6NlRNlwYOQACPbFxXIf0/aFa/3uSP6/TeB4E4no2MOUcSRXdYy
 hicnxgTiint5HSWqJSBn76wOOo51hiXGr9AtLqr2BX6MOOkchU
 X7pP6w5zHk7CaB59gZl/zqJo7fjmodh3PTxn07/3P4d0SrHJuF
 BLGOANnMrt0OxCPuoksBQd9zA/1K4gozYjhvbwGNrwVWP11hec
 BHKvJMJiliy+/fVqFqZwU0YVa6jVa0LkVTOFswQ2j7EcSlkeJT
 Je9Vq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the pwm-backlight driver is lacking a proper maintainer and is the
heaviest user of the PWM framework I'm taking over maintenance.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arun Murthy <arun.murthy@stericsson.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Robert Morell <rmorell@nvidia.com>
Cc: Dilan Lee <dilee@nvidia.com>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Andrew: As previously discussed this patch makes me the new maintainer
for the pwm-backlight driver. I contacted Richard Purdie and requested
his Acked-by for this because he's the backlight subsystem maintainer.
Unfortunately he hasn't answered yet. Looking at the commit log, every
commit in the last 2+ years has gone through your tree, which seems to
be reason enough for me to take over this driver but I still wanted to
get an Acked-by at least from you so that this doesn't look like
hijacking. I've also Cc'ed a couple of people that have done work on
the driver in the past to give them a chance to object or send their
Acked-by.

Obviously I will take this patch through my tree so this is not a
request to include it in your tree.

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61ad79e..a6f023e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5543,6 +5543,8 @@ F:	Documentation/devicetree/bindings/pwm/
 F:	include/linux/pwm.h
 F:	include/linux/of_pwm.h
 F:	drivers/pwm/
+F:	drivers/video/backlight/pwm_bl.c
+F:	include/linux/pwm_backlight.h
 
 PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
-- 
1.7.12

