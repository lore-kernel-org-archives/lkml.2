Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1KREpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:45:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49474 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab1KREpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:45:43 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 5/5] Drivers: video: riva: riva_hw: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 21:45:37 -0700
Message-Id: <1321591537-8475-1-git-send-email-zac.3.14159@gmail.com>
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
index 78fdbf5..c4b8a6f 100644
--- a/drivers/video/riva/riva_hw.c
+++ b/drivers/video/riva/riva_hw.c
@@ -994,7 +994,7 @@ static void nv10CalcArbitration
               clwm = clwm_mt;
   */
           /* Finally, a heuristic check when width == 64 bits */
-          if(width == 1){
+          if(width == 1) {
               nvclk_fill = nvclk_freq * 8;
               if(crtc_drain_rate * 100 >= nvclk_fill * 102)
                       clwm = 0xfff; /*Large number to fail */
-- 
1.7.7.3

