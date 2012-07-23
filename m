Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2GWRu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:50:26 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:55602
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369Ab2GWRuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:50:23 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah107ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 5/5] staging: ozwpan: Bump version number
Date: Mon, 23 Jul 2012 18:49:47 +0100
Message-ID: <1343065787-7616-6-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
References: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump version numbers to keep in sync with internal
version information.

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozmain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ozwpan/ozmain.c b/drivers/staging/ozwpan/ozmain.c
index c1ed6b2..ef6c5ab 100644
--- a/drivers/staging/ozwpan/ozmain.c
+++ b/drivers/staging/ozwpan/ozmain.c
@@ -59,6 +59,6 @@ module_exit(ozwpan_exit);
 
 MODULE_AUTHOR("Chris Kelly");
 MODULE_DESCRIPTION("Ozmo Devices USB over WiFi hcd driver");
-MODULE_VERSION("1.0.10");
+MODULE_VERSION("1.0.13");
 MODULE_LICENSE("GPL");
 
-- 
1.7.5.4


