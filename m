Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0IKORt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:17:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62351 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab0IKORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ofY8i269EesZuXLRecdrzNz8/aKVqeG2IsFuW6TMF4B/cDDjqNiHzyJL1Whn4FI0ez
         EsaHULfCe0+tUsL3kqIPnbyVySRsgIEZ89eShujMZoMEugPw8zuZvpFYcS95fdw8caTO
         KbPrtBYLAjs+CYVfzJk9S0Jc71+WkAeOpY2/s=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 10/10] staging: wlags49_h2: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:13 +0300
Message-Id: <6799bf24203f3f093c411094c477e063299dcf07.1284214461.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/wlags49_h2/wl_util.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index ce8ed41..e510dcb 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -338,9 +338,7 @@ const char *DbgHwAddr(unsigned char *hwAddr)
     static char     buffer[18];
     /*------------------------------------------------------------------------*/
 
-
-    sprintf( buffer, "%02X:%02X:%02X:%02X:%02X:%02X",
-             hwAddr[0], hwAddr[1], hwAddr[2], hwAddr[3], hwAddr[4], hwAddr[5] );
+	sprintf(buffer, "%pM", &hwAddr[0]);
 
     return buffer;
 } // DbgHwAddr
-- 
1.7.2.2

