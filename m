Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0IMIlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:41:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56247 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0IMIlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rKKcnVuleSvwSaydTre5jcCYLMj7F10xTjiKVaiijiAEDAIZO1ECDgvZYKh8+Tiv//
         oIDOh+w6PyB9f8GGoMstAiJu5Z4vgQfDMxafhQlac3tPMeaV5Ex/dFWwFohBuPUg3Cfn
         GvoNBv3qy82QXXsXQss8Y7SigDQEmmIPcLCZE=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 10/10] staging: wlags49_h2: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:34 +0300
Message-Id: <3ffdfd58c5e9793c6ddd55a09db0af5c64b9685d.1284316741.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/wlags49_h2/wl_util.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index ce8ed41..4521c9f 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -338,9 +338,7 @@ const char *DbgHwAddr(unsigned char *hwAddr)
     static char     buffer[18];
     /*------------------------------------------------------------------------*/
 
-
-    sprintf( buffer, "%02X:%02X:%02X:%02X:%02X:%02X",
-             hwAddr[0], hwAddr[1], hwAddr[2], hwAddr[3], hwAddr[4], hwAddr[5] );
+	sprintf(buffer, "%pM", hwAddr);
 
     return buffer;
 } // DbgHwAddr
-- 
1.7.2.2

