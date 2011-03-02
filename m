Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1CBXsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:48:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57732 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755636Ab1CBXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:48:50 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX19sihohv+5s9i4yExplgtiUOG2pzc/WaHIMgabHkM
	Y9W8U0c/zulAKA
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH 1/2] staging: keucr: remove unused typedef VOID
Date: Thu,  3 Mar 2011 00:48:13 +0100
Message-Id: <1299109694-28758-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.4.1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/keucr/common.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
index 8693c54..f2be045 100644
--- a/drivers/staging/keucr/common.h
+++ b/drivers/staging/keucr/common.h
@@ -1,7 +1,6 @@
 #ifndef COMMON_INCD
 #define COMMON_INCD
 
-typedef void VOID;
 typedef u8 BOOLEAN;
 typedef u8 BYTE;
 typedef u8 *PBYTE;
-- 
1.7.4.1

