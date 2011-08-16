Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1HPAZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:25:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40180 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1HPAZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:25:56 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Akshay Joshi <me@akshayjoshi.com>,
        Chihau Chau <chihau@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] Staging: Winbond: Fix parentheses in returns.
Date: Mon, 15 Aug 2011 20:24:33 -0400
Message-Id: <1313454275-5604-7-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes parentheses when calling return, since return is not a function.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/phy_calibration.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index c5a07fb..816fe7c 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -51,7 +51,7 @@ s32 _s13_to_s32(u32 data)
 	if ((data & BIT(12)) != 0)
 		val |= 0xFFFFF000;
 
-	return ((s32) val);
+	return (s32)val;
 }
 
 u32 _s32_to_s13(s32 data)
@@ -184,7 +184,7 @@ s32 _floor(s32 n)
 	else
 		n -= 5;
 
-	return (n/10);
+	return n/10;
 }
 
 /****************************************************************************/
-- 
1.7.5.4

