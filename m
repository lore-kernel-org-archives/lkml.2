Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2KTRaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:30:07 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34109 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2KTRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:30:03 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 09/10] staging: cxt1e1: sbecrc.c: fixes coding style issue
Date: Tue, 20 Nov 2012 19:28:51 +0200
Message-Id: <1353432532-21203-9-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out a coding style issue related to spaces between
parentheses and function names.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/sbecrc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
index f95728e..87512a5 100644
--- a/drivers/staging/cxt1e1/sbecrc.c
+++ b/drivers/staging/cxt1e1/sbecrc.c
@@ -44,7 +44,7 @@ static u_int32_t CRCTable[CRC_TABLE_ENTRIES];
 ***************************************************************************/
 
 static void
-genCrcTable (u_int32_t *CRCTable)
+genCrcTable(u_int32_t *CRCTable)
 {
 	int         ii, jj;
 	u_int32_t      crc;
@@ -83,7 +83,7 @@ genCrcTable (u_int32_t *CRCTable)
 */
 
 void
-sbeCrc (u_int8_t *buffer,          /* data buffer to crc */
+sbeCrc(u_int8_t *buffer,          /* data buffer to crc */
 	u_int32_t count,           /* length of block in bytes */
 	u_int32_t initialCrc,      /* starting CRC */
 	u_int32_t *result)
@@ -99,15 +99,15 @@ sbeCrc (u_int8_t *buffer,          /* data buffer to crc */
 	if (!crcTableInit) {
 #ifdef STATIC_CRC_TABLE
 		tbl = &CRCTable;
-		genCrcTable (tbl);
+		genCrcTable(tbl);
 #else
-		tbl = (u_int32_t *) OS_kmalloc (CRC_TABLE_ENTRIES * sizeof (u_int32_t));
+		tbl = (u_int32_t *) OS_kmalloc(CRC_TABLE_ENTRIES * sizeof(u_int32_t));
 		if (tbl == 0) {
 			*result = 0;   /* dummy up return value due to malloc
 					* failure */
 			return;
 		}
-		genCrcTable (tbl);
+		genCrcTable(tbl);
 #endif
 	}
 	/* inverting bits makes ZMODEM & PKZIP compatible */
@@ -125,7 +125,7 @@ sbeCrc (u_int8_t *buffer,          /* data buffer to crc */
 
 #ifndef STATIC_CRC_TABLE
 	crcTableInit = 0;
-	OS_kfree (tbl);
+	OS_kfree(tbl);
 #endif
 }
 
-- 
1.7.10.4

