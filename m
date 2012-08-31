Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2HaJZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:25:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44573 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab2HaJZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:25:51 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/22] lp8727_charger: make lp8727_ctrl_switch() inline
Thread-Topic: [PATCH 14/22] lp8727_charger: make lp8727_ctrl_switch() inline
Thread-Index: Ac2HWpjFkWeLxjqeQOCd6nvJNyVhfA==
Date: Fri, 31 Aug 2012 09:25:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1F1C@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 47cce41..880bb7b 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -169,7 +169,7 @@ static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
 	return val & LP8727_CHPORT;
 }
 
-static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
+static inline void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
 {
 	lp8727_write_byte(pchg, LP8727_SWCTRL, sw);
 }
-- 
1.7.9.5

Best Regards,
Milo


