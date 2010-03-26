Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0CZXfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:35:08 -0400
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:45200 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab0CZXfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:35:06 -0400
X-MXL-Hash: 4bad44aa1cd44301-d6afe3bc7600c32a63332243184ca92145b96f97
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Richard Purdie <rpurdie@rpsys.net>
Date: Fri, 26 Mar 2010 18:35:01 -0500
Subject: [PATCH] leds: one more Kconfig cleanup
Thread-Topic: [PATCH] leds: one more Kconfig cleanup
Thread-Index: AcrNPPRLyHcdcbj0Ti2JhlmznCKWRA==
Message-ID: <0D753D10438DA54287A00B02708426976369012EB6@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010032501)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=eDf0YQ-qUCcA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=-sM]
X-AnalysisOut: [3sDvmAAAA:8 a=uGX0d3vinQEKwjOvw9sA:9 a=asazQq2PvJ7qU-rT141]
X-AnalysisOut: [AGlSP0PwA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=130E6OD_]
X-AnalysisOut: [8ZAA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2QNZImE020918

Looks like the a new led driver was merged that still has
"depends on LEDS_CLASS".  This is no longer needed since the
config options are wrapped in an if/endif block.
    
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>

---

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 505eb64..676a72b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -21,7 +21,7 @@ comment "LED drivers"
 
 config LEDS_88PM860X
 	tristate "LED Support for Marvell 88PM860x PMIC"
-	depends on LEDS_CLASS && MFD_88PM860X
+	depends on MFD_88PM860X
 	help
 	  This option enables support for on-chip LED drivers found on Marvell
 	  Semiconductor 88PM8606 PMIC.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
