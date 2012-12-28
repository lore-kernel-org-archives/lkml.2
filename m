Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2L1TRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54932 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab2L1TRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:05 -0500
Message-Id: <20121228190402.520617408@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 169/173] staging: vt6656: 64 bit fixes : correct all type sizes
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

commit 7730492855a2f9c828599bcd8d62760f96d319e4 upstream.

After this patch all BYTE/WORD/DWORD types can be replaced with the appropriate u sizes.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/ttype.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 0f70562c..dfbf747 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -44,9 +44,9 @@ typedef int             BOOL;
 
 /****** Simple typedefs  ***************************************************/
 
-typedef unsigned char   BYTE;           //  8-bit
-typedef unsigned short  WORD;           // 16-bit
-typedef unsigned long   DWORD;          // 32-bit
+typedef u8 BYTE;
+typedef u16 WORD;
+typedef u32 DWORD;
 
 // QWORD is for those situation that we want
 // an 8-byte-aligned 8 byte long structure
@@ -62,8 +62,8 @@ typedef UQuadWord       QWORD;          // 64-bit
 
 /****** Common pointer types ***********************************************/
 
-typedef unsigned long   ULONG_PTR;      // 32-bit
-typedef unsigned long   DWORD_PTR;      // 32-bit
+typedef u32 ULONG_PTR;
+typedef u32 DWORD_PTR;
 
 // boolean pointer
 


