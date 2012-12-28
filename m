Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2L1T5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:57:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54930 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313Ab2L1TRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:02 -0500
Message-Id: <20121228190402.792026365@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 171/173] staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit c0d05b305b00c698b0a8c1b3d46c9380bce9db45 upstream.

Fixes long issues.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/key.c |    6 +++---
 drivers/staging/vt6656/key.h |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 617fda1..bf24adb 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -223,7 +223,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -675,7 +675,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -791,7 +791,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index f749c7a..bd35d39 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -58,7 +58,7 @@
 typedef struct tagSKeyItem
 {
     BOOL        bKeyValid;
-    unsigned long       uKeyLength;
+	u32 uKeyLength;
     BYTE        abyKey[MAX_KEY_LEN];
     QWORD       KeyRSC;
     DWORD       dwTSC47_16;
@@ -107,7 +107,7 @@ BOOL KeybSetKey(
     PSKeyManagement pTable,
     PBYTE           pbyBSSID,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -146,7 +146,7 @@ BOOL KeybSetDefaultKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode
@@ -156,7 +156,7 @@ BOOL KeybSetAllGroupKey(
     void *pDeviceHandler,
     PSKeyManagement pTable,
     DWORD           dwKeyIndex,
-    unsigned long           uKeyLength,
+	u32 uKeyLength,
     PQWORD          pKeyRSC,
     PBYTE           pbyKey,
     BYTE            byKeyDecMode


