Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab2HWN1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:27:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:29492 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933964Ab2HWN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:27:34 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <cjb@laptop.org>, <ludovic.desroches@atmel.com>, <plagnioj@jcrosoft.com>,
        <arnd@arndb.de>, <olof@lixom.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/feature-removal-schedule: delay at91_mci removal
Date: Thu, 23 Aug 2012 15:27:28 +0200
Message-ID: <1345728448-29384-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Delay sd/mmc driver at91_mci.c removal because of tight schedule to
move platform data to new driver atmel-mci.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi,

I plan to queue this one with the at91-fixes pull-request for 3.6. If you do
not feel it is a good idea, please say so.


 Documentation/feature-removal-schedule.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index afaff31..f4d8c71 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -579,7 +579,7 @@ Why:	KVM tracepoints provide mostly equivalent information in a much more
 ----------------------------
 
 What:	at91-mci driver ("CONFIG_MMC_AT91")
-When:	3.7
+When:	3.8
 Why:	There are two mci drivers: at91-mci and atmel-mci. The PDC support
 	was added to atmel-mci as a first step to support more chips.
 	Then at91-mci was kept only for old IP versions (on at91rm9200 and
-- 
1.7.10

