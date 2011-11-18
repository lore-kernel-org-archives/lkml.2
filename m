Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1KREuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:50:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47542 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab1KREuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:50:50 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: adaplas@gmail.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 6/6] Drivers: video: riva: riva_hw: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 21:50:45 -0700
Message-Id: <1321591845-8610-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/video/riva/riva_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/riva/riva_hw.c b/drivers/video/riva/riva_hw.c
index c4b8a6f..5cd1d71 100644
--- a/drivers/video/riva/riva_hw.c
+++ b/drivers/video/riva/riva_hw.c
@@ -1038,7 +1038,7 @@ static void nv10CalcArbitration
             min_mclk_extra--;
           }
       } else {
-        if (clwm > 1023){ /* Have some margin */
+        if (clwm > 1023) { /* Have some margin */
           fifo->valid = 0;
           found = 0;
           if(min_mclk_extra == 0)   
-- 
1.7.7.3

