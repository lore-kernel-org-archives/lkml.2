Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2FZMEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:04:21 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:49943
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756566Ab2FZMEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:04:16 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT001.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Rupesh Gujare <rgujare@ozmodevices.com>
Subject: [PATCH 3/3] staging: ozwpan: Update TODO file
Date: Tue, 26 Jun 2012 13:03:41 +0100
Message-ID: <1340712221-6750-4-git-send-email-rgujare@ozmodevices.com>
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

Update TODO file.

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/TODO |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ozwpan/TODO b/drivers/staging/ozwpan/TODO
index c2d30a7..b5db245 100644
--- a/drivers/staging/ozwpan/TODO
+++ b/drivers/staging/ozwpan/TODO
@@ -1,10 +1,11 @@
 TODO:
-	- review user mode interface and determine if ioctls can be replaced
-	  with something better. correctly export data structures to user mode
-	  if ioctls are still required and allocate ioctl numbers from
-	  ioctl-number.txt.
+	- Convert event tracing code to in-kernel tracing infrastructure
+	- Check for remaining ioctl & check if that can be converted into
+	  sysfs entries
+	- Convert debug prints to appropriate dev_debug or something better
+	- Modify Kconfig to add CONFIG option for enabling/disabling event
+	  tracing.
 	- check USB HCD implementation is complete and correct.
-	- remove any debug and trace code.
 	- code review by USB developer community.
 	- testing with as many devices as possible.
 
-- 
1.7.5.4


