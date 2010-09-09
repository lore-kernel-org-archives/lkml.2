Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab0IIWhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:37:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50159 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab0IIWhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=r2VJPsJWMcu0olo5Kr2dp1a2jmit+62Y5xTfzYgEzoAu0DXofv/0GgyvSM5HFBBATx
         drEDWzduZQCY/4qxSsPpXCk7i8J5a8+1uTEGvkjdVpLAHypzsSlC5KTIwSx6JPlZvOjM
         mQduYQx9gt78cdsjJwbdRXWqSPrzojZEohUL0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 121/223]drivers/net/natsemi.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:28 -0700
Message-Id: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/natsemi.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index a6033d4..a8c6d3c 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -19,9 +19,7 @@
 	Annapolis MD 21403
 
 	Support information and updates available at
-	http://www.scyld.com/network/netsemi.html
-	[link no longer provides useful info -jgarzik]
-
+	http://www.penguincomputing.com/	
 
 	TODO:
 	* big endian support with CFG:BEM instead of cpu_to_le32
@@ -207,9 +205,7 @@ recieve and transmit paths which are synchronised using a combination of
 hardware descriptor ownership, disabling interrupts and NAPI poll scheduling.
 
 IVb. References
-
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://www.penguincomputing.com/
 Datasheet is available from:
 http://www.national.com/pf/DP/DP83815.html
 
@@ -223,7 +219,7 @@ None characterised.
 /*
  * Support for fibre connections on Am79C874:
  * This phy needs a special setup when connected to a fibre cable.
- * http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/22235.pdf
+ * http://web.archive.org/web/*/http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/22235.pdf 
  */
 #define PHYID_AM79C874	0x0022561b
 
-- 
1.7.2.1

