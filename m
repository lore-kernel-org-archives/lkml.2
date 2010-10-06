Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab0JFBBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab0JFBBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RQ5TJymCumAQ9c55antxegzRi1vEmGwgJaaqjHskRsgHG1cRuEtgnLQH8ZACmIUM5N
         9nPaJAeUfd/vTV1RKtab+OFIG1pwxk6ZCQxppBiuPB9lBSd6dXrlysA4SAzQz+DdYREI
         Rn0jwpRuf1o/IXUFzQUC0CA1mDR7FNNXreLec=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 28/28] Staging: comedi: drivers: amcc_s5933.h:  Edit file so that checkpatch.pl has 2 warnings and 0 errors
Date: Tue,  5 Oct 2010 21:00:43 -0400
Message-Id: <1286326843-6170-28-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. Could not get ever error but
I got it down to to just two, WARNING: line over 80 characters.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers/amcc_s5933.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amcc_s5933.h b/drivers/staging/comedi/drivers/amcc_s5933.h
index b810d5f..e87c4e7 100644
--- a/drivers/staging/comedi/drivers/amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/amcc_s5933.h
@@ -1,15 +1,15 @@
 /*
-    comedi/drivers/amcc_s5933.h
+	comedi/drivers/amcc_s5933.h
 
-    Stuff for AMCC S5933 PCI Controller
+	Stuff for AMCC S5933 PCI Controller
 
-    Author: Michal Dobes <dobes@tesnet.cz>
+	Author: Michal Dobes <dobes@tesnet.cz>
 
-    Inspirated from general-purpose AMCC S5933 PCI Matchmaker driver
-    made by Andrea Cisternino  <acister@pcape1.pi.infn.it>
-    and as result of espionage from MITE code made by David A. Schleef.
-    Thanks to AMCC for their on-line documentation and bus master DMA
-    example.
+	Inspirated from general-purpose AMCC S5933 PCI Matchmaker driver
+	made by Andrea Cisternino  <acister@pcape1.pi.infn.it>
+	and as result of espionage from MITE code made by David A. Schleef.
+	Thanks to AMCC for their on-line documentation and bus master DMA
+	example.
 */
 
 #ifndef _AMCC_S5933_H_
@@ -41,7 +41,7 @@
 #define  AMCC_OP_REG_MCSR_NVCMD  (AMCC_OP_REG_MCSR + 3)	/* Command in byte 3 */
 
 #define AMCC_FIFO_DEPTH_DWORD	8
-#define AMCC_FIFO_DEPTH_BYTES	(8 * sizeof (u32))
+#define AMCC_FIFO_DEPTH_BYTES	(8 * sizeof(u32))
 
 /****************************************************************************/
 /* AMCC - PCI Interrupt Control/Status Register                            */
@@ -145,12 +145,12 @@
 #define AINT_READ_COMPL		0x00008000
 #define AINT_WRITE_COMPL	0x00004000
 
-#define AINT_OMB_ENABLE 	0x00001000
-#define AINT_OMB_SELECT 	0x00000c00
+#define AINT_OMB_ENABLE		0x00001000
+#define AINT_OMB_SELECT		0x00000c00
 #define AINT_OMB_BYTE		0x00000300
 
-#define AINT_IMB_ENABLE 	0x00000010
-#define AINT_IMB_SELECT 	0x0000000c
+#define AINT_IMB_ENABLE		0x00000010
+#define AINT_IMB_SELECT		0x0000000c
 #define AINT_IMB_BYTE		0x00000003
 
 /* these are bits from various different registers, needs cleanup XXX */
-- 
1.7.3.1.50.g1e633

