Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2HRNPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 09:15:24 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:55361 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2HRNPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 09:15:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/apollo: Remove disabled definitions in apollohw.h
Date: Sat, 18 Aug 2012 15:15:14 +0200
Message-Id: <1345295714-13030-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/apollohw.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/m68k/include/asm/apollohw.h b/arch/m68k/include/asm/apollohw.h
index 635ef4f..6c19e0c 100644
--- a/arch/m68k/include/asm/apollohw.h
+++ b/arch/m68k/include/asm/apollohw.h
@@ -46,18 +46,6 @@ struct SCN2681 {
 
 };
 
-#if 0
-struct mc146818 {
-
-	unsigned int second1:4, second2:4, alarm_second1:4, alarm_second2:4,
-		     minute1:4, minute2:4, alarm_minute1:4, alarm_minute2:4;
-	unsigned int hours1:4, hours2:4, alarm_hours1:4, alarm_hours2:4,
-		     day_of_week1:4, day_of_week2:4, day_of_month1:4, day_of_month2:4;
-	unsigned int month1:4, month2:4, year1:4, year2:4, :16;
-
-};
-#endif
-
 struct mc146818 {
         unsigned char second, alarm_second;
         unsigned char minute, alarm_minute;
-- 
1.7.0.4

