Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2L1TRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54941 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326Ab2L1TRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:05 -0500
Message-Id: <20121228190402.389451778@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 168/173] staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
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

commit a552397d5e4ef0cc0bd3e9595d6acc9a3b381171 upstream.

Size of long issues replace with u32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/ttype.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 8e9450e..0f70562c 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -29,6 +29,8 @@
 #ifndef __TTYPE_H__
 #define __TTYPE_H__
 
+#include <linux/types.h>
+
 /******* Common definitions and typedefs ***********************************/
 
 typedef int             BOOL;
@@ -51,8 +53,8 @@ typedef unsigned long   DWORD;          // 32-bit
 // which is NOT really a floating point number.
 typedef union tagUQuadWord {
     struct {
-        DWORD   dwLowDword;
-        DWORD   dwHighDword;
+	u32 dwLowDword;
+	u32 dwHighDword;
     } u;
     double      DoNotUseThisField;
 } UQuadWord;


