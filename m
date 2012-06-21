Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2FUIE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:04:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39901 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab2FUIEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:04:05 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: [PATCH 3/3] regulator: change message level on probing lp872x driver
Thread-Topic: [PATCH 3/3] regulator: change message level on probing lp872x
 driver
Thread-Index: Ac1PhGeSPzZoFKRLQp63JgNKPMRTng==
Date: Thu, 21 Jun 2012 08:03:56 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FC05A@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use err log rather than warning message when the platform data is NULL

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp872x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index daaa0ed..0c0e62f 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -891,7 +891,7 @@ static int lp872x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	};
 
 	if (!pdata) {
-		dev_warn(&cl->dev, "no platform data\n");
+		dev_err(&cl->dev, "no platform data\n");
 		return -EINVAL;
 	}
 
-- 
1.7.2.5


Best Regards,
Milo (Woogyom) Kim



