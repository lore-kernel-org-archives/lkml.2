Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2FZMEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:04:14 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:47362
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab2FZMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:04:11 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Rupesh Gujare <rgujare@ozmodevices.com>
Subject: [PATCH 2/3] staging: ozwpan: Fix compilation issue due to export.h
Date: Tue, 26 Jun 2012 13:03:40 +0100
Message-ID: <1340712221-6750-3-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340712221-6750-1-git-send-email-rgujare@ozmodevices.com>
References: <1340712221-6750-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compilation error caused due to header file.

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 251f07c..e3efa41 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -28,7 +28,7 @@
 #include <linux/usb.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include "linux/usb/hcd.h"
 #include <asm/unaligned.h>
 #include "ozconfig.h"
-- 
1.7.5.4


