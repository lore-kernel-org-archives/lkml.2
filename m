Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2A0G7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:59:32 -0500
Received: from mail2.nsc.com ([12.238.8.132]:33843 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572Ab2A0G72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:59:28 -0500
X-WSS-ID: 0LYG3F0-0A-25W-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 22:59:08 -0800
Subject: [PATCH 6/6] lp8727_charger: correct typos on the comment
Thread-Topic: [PATCH 6/6] lp8727_charger: correct typos on the comment
Thread-Index: AczcwSqMTwjz7UYcReimbevWAB0FTA==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB0B@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633C94B41LS9965386-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intergrated charger -> integrated charger
    ^

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/power/lp8727_charger.c |    2 +-
 include/linux/lp8727.h         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b531725..ccee42c 100755
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -1,5 +1,5 @@
 /*
- * Driver for LP8727 Micro/Mini USB IC with intergrated charger
+ * Driver for LP8727 Micro/Mini USB IC with integrated charger
  *
  *			Copyright (C) 2011 Texas Instruments
  *
diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
index 9a4611f..4397e07 100644
--- a/include/linux/lp8727.h
+++ b/include/linux/lp8727.h
@@ -1,5 +1,5 @@
 /*
- * LP8727 Micro/Mini USB IC with intergrated charger
+ * LP8727 Micro/Mini USB IC with integrated charger
  *
  *			Copyright (C) 2011 Texas Instruments
  *
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




