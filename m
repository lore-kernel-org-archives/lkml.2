Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2BTKNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:13:32 -0500
Received: from mail2.nsc.com ([12.238.8.132]:44110 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752522Ab2BTKNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:13:11 -0500
X-WSS-ID: 0LZOSDU-0A-4QL-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Richard Purdie" <rpurdie@rpsys.net>
Date: Mon, 20 Feb 2012 02:13:02 -0800
Subject: [PATCH 2/2] lp855x-bl: remove unnecessary headers
Thread-Topic: [PATCH 2/2] lp855x-bl: remove unnecessary headers
Thread-Index: AczvuDr0bO/lEdaiQNa3EhSxtqaDfg==
Message-ID: <B567DBAB974C0544994013492B949F8E3813076552@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 635CC3221LS10491314-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 640624b..37831ef 100755
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -14,8 +14,6 @@
 #include <linux/i2c.h>
 #include <linux/backlight.h>
 #include <linux/err.h>
-#include <linux/debugfs.h>
-#include <linux/uaccess.h>
 #include <linux/lp855x.h>
 
 /* Registers */
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




