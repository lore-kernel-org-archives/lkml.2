Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0C2MTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:19:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52771 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0C2MTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lQzE/YuAbHehqn9em8Jv3daEr1tsSdf5opmRwgNQYtU3SmDT/RFEkyttN+Q92g018E
         MEZZggwSOW7RlVoKc0im+3ozwdMY9JjW27cyzexKUBkzYBmO1UxjDhjJERyF1bdRpGVB
         KFqvrG+VD05OuvOPMzrm5hD06fjGC4M1LEwY4=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 8/8] staging: vt6656: tcrc.c: Fixed coding style issues
Date: Mon, 29 Mar 2010 23:19:20 +1100
Message-Id: <1269865160-17572-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed minor problems with indentation.
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/vt6656/tcrc.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/tcrc.c b/drivers/staging/vt6656/tcrc.c
index 5f0c747..3464801 100644
--- a/drivers/staging/vt6656/tcrc.c
+++ b/drivers/staging/vt6656/tcrc.c
@@ -41,7 +41,7 @@
 
 /*---------------------  Static Variables  --------------------------*/
 
-// 32-bit CRC table
+/* 32-bit CRC table */
 static const DWORD s_adwCrc32Table[256] = {
     0x00000000L, 0x77073096L, 0xEE0E612CL, 0x990951BAL,
     0x076DC419L, 0x706AF48FL, 0xE963A535L, 0x9E6495A3L,
@@ -132,17 +132,18 @@ static const DWORD s_adwCrc32Table[256] = {
  * Return Value: CRC-32
  *
 -*/
-DWORD CRCdwCrc32 (PBYTE pbyData, UINT cbByte, DWORD dwCrcSeed)
+DWORD CRCdwCrc32(PBYTE pbyData, UINT cbByte, DWORD dwCrcSeed)
 {
-    DWORD dwCrc;
+	DWORD dwCrc;
 
-    dwCrc = dwCrcSeed;
-    while (cbByte--) {
-        dwCrc = s_adwCrc32Table[(BYTE)((dwCrc ^ (*pbyData)) & 0xFF)] ^ (dwCrc >> 8);
-        pbyData++;
-    }
+	dwCrc = dwCrcSeed;
+	while (cbByte--) {
+		dwCrc = s_adwCrc32Table[(BYTE)((dwCrc ^ (*pbyData)) & 0xFF)] ^
+			(dwCrc >> 8);
+		pbyData++;
+	}
 
-    return dwCrc;
+	return dwCrc;
 }
 
 
@@ -164,7 +165,7 @@ DWORD CRCdwCrc32 (PBYTE pbyData, UINT cbByte, DWORD dwCrcSeed)
  * Return Value: CRC-32
  *
 -*/
-DWORD CRCdwGetCrc32 (PBYTE pbyData, UINT cbByte)
+DWORD CRCdwGetCrc32(PBYTE pbyData, UINT cbByte)
 {
     return ~CRCdwCrc32(pbyData, cbByte, 0xFFFFFFFFL);
 }
-- 
1.6.3.3

