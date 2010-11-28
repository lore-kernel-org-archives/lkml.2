Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0K1VAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:00:13 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37373 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0K1VAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:11 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 01/13] w35und: Remove unused defines from sysdef.h
Date: Sun, 28 Nov 2010 22:59:56 +0200
Message-Id: <1290978008-29095-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all the defines in sysdef.h that are not used at all.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/sysdef.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/sysdef.h b/drivers/staging/winbond/sysdef.h
index 9195adf..7198708 100644
--- a/drivers/staging/winbond/sysdef.h
+++ b/drivers/staging/winbond/sysdef.h
@@ -2,17 +2,11 @@
 
 #ifndef SYS_DEF_H
 #define SYS_DEF_H
-#define WB_LINUX
-#define WB_LINUX_WPA_PSK
 
 #define _USE_FALLBACK_RATE_
 
 #define _WPA2_
 
-#ifndef _WPA_PSK_DEBUG
-#undef  _WPA_PSK_DEBUG
-#endif
-
 /* debug print options, mark what debug you don't need */
 
 #ifdef FULL_DEBUG
-- 
1.7.0.4

