Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2BQGmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 01:42:38 -0500
Received: from mail2.nsc.com ([12.238.8.132]:60197 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805Ab2BQGmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 01:42:35 -0500
X-WSS-ID: 0LZIYMU-0A-2HQ-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Feb 2012 22:42:16 -0800
Subject: [PATCH 3/3] regulator: remove braces for single statement
Thread-Topic: [PATCH 3/3] regulator: remove braces for single statement
Thread-Index: AcztP0oWWpst0hnLQcKML5+wAtafwg==
Message-ID: <B567DBAB974C0544994013492B949F8E381301284F@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6323294D1LS10440593-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* patch base version : linux-3.2.4

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3053f4f..3003a96 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3092,9 +3092,8 @@ static int __init regulator_init_complete(void)
 			 * goes wrong. */
 			rdev_info(rdev, "disabling\n");
 			ret = ops->disable(rdev);
-			if (ret != 0) {
+			if (ret != 0)
 				rdev_err(rdev, "couldn't disable: %d\n", ret);
-			}
 		} else {
 			/* The intention is that in future we will
 			 * assume that full constraints are provided
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




