Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0CUVbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:31:31 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:50175 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0CUVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:31:28 -0400
X-SENDER-IP: [83.226.249.129]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AldCAHsspktT4vmBPGdsb2JhbACbOQwBAQEBNy2rRIxXhH0E
X-IronPort-AV: E=Sophos;i="4.51,284,1267398000"; 
   d="scan'208";a="53862797"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: sysdef.h Coding style fixes.
Date: Sun, 21 Mar 2010 22:31:30 +0100
Message-Id: <1269207090-4941-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the C99 comments and removed commented away code.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/sysdef.h |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/winbond/sysdef.h b/drivers/staging/winbond/sysdef.h
index 251b9c5..9195adf 100644
--- a/drivers/staging/winbond/sysdef.h
+++ b/drivers/staging/winbond/sysdef.h
@@ -1,31 +1,19 @@
+/*  Winbond WLAN System Configuration defines */
 
-
-//
-// Winbond WLAN System Configuration defines
-//
-
-//=====================================================================
-// Current directory is Linux
-// The definition WB_LINUX is a keyword for this OS
-//=====================================================================
 #ifndef SYS_DEF_H
 #define SYS_DEF_H
 #define WB_LINUX
 #define WB_LINUX_WPA_PSK
 
-
-//#define _IBSS_BEACON_SEQ_STICK_
 #define _USE_FALLBACK_RATE_
-//#define ANTDIV_DEFAULT_ON
-
-#define _WPA2_	// 20061122 It's needed for current Linux driver
 
+#define _WPA2_
 
 #ifndef _WPA_PSK_DEBUG
 #undef  _WPA_PSK_DEBUG
 #endif
 
-// debug print options, mark what debug you don't need
+/* debug print options, mark what debug you don't need */
 
 #ifdef FULL_DEBUG
 #define _PE_STATE_DUMP_
-- 
1.7.0.2

