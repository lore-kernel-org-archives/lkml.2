Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1BBBJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:09:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:1497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab1BBAn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504911"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: sw.youn@samsung.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [22/139] ASoC: WM8580: Fix R8 initial value
Message-Id: <20110202004336.D2B643E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Seungwhan Youn <sw.youn@samsung.com>

commit a0968628097380be52db8b4664da98fc425546a5 upstream.

Acc to WM8580 manual, the default value for R8 is 0x10, not 0x1c.

Signed-off-by: Seungwhan Youn <sw.youn@samsung.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm8580.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/sound/soc/codecs/wm8580.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm8580.c
+++ linux-2.6.35.y/sound/soc/codecs/wm8580.c
@@ -171,7 +171,7 @@
 static const u16 wm8580_reg[] = {
 	0x0121, 0x017e, 0x007d, 0x0014, /*R3*/
 	0x0121, 0x017e, 0x007d, 0x0194, /*R7*/
-	0x001c, 0x0002, 0x0002, 0x00c2, /*R11*/
+	0x0010, 0x0002, 0x0002, 0x00c2, /*R11*/
 	0x0182, 0x0082, 0x000a, 0x0024, /*R15*/
 	0x0009, 0x0000, 0x00ff, 0x0000, /*R19*/
 	0x00ff, 0x00ff, 0x00ff, 0x00ff, /*R23*/
