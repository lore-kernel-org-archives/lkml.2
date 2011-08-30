Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1H3GrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:47:05 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:16994
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994Ab1H3GrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:47:01 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Jason Liu <jason.hui@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <patches@linaro.org>, <cl@linux-foundation.org>
Subject: [PATCH] slub: doc: update the slabinfo.c file path
Date: Tue, 30 Aug 2011 14:52:06 +0800
Message-ID: <1314687126-23252-1-git-send-email-jason.hui@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slabinfo.c has been moved from Documentaion/vm/ to
tools/slub/ by commit:0d24db337e6d81c0c620ab65cc6947bd6553f742

Update the slub.txt doc to reflect this change too.

Signed-off-by: Jason Liu <jason.hui@linaro.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 Documentation/vm/00-INDEX |    2 --
 Documentation/vm/slub.txt |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/00-INDEX b/Documentation/vm/00-INDEX
index dca82d7..5481c8b 100644
--- a/Documentation/vm/00-INDEX
+++ b/Documentation/vm/00-INDEX
@@ -30,8 +30,6 @@ page_migration
 	- description of page migration in NUMA systems.
 pagemap.txt
 	- pagemap, from the userspace perspective
-slabinfo.c
-	- source code for a tool to get reports about slabs.
 slub.txt
 	- a short users guide for SLUB.
 unevictable-lru.txt
diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
index 07375e7..f464f47 100644
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -17,7 +17,7 @@ data and perform operation on the slabs. By default slabinfo only lists
 slabs that have data in them. See "slabinfo -h" for more options when
 running the command. slabinfo can be compiled with
 
-gcc -o slabinfo Documentation/vm/slabinfo.c
+gcc -o slabinfo tools/slub/slabinfo.c
 
 Some of the modes of operation of slabinfo require that slub debugging
 be enabled on the command line. F.e. no tracking information will be
-- 
1.7.4.1


