Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0LLSDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:03:24 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:54980
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753483Ab0LLSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:03:23 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 13:03:22 EST
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
Subject: [PATCH 1/3] Staging: rt2860: Clean spaces before tabs
Date: Sun, 12 Dec 2010 18:56:29 +0100
Message-Id: <1292176591-26081-2-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch complains

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rt2860/oid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/oid.h b/drivers/staging/rt2860/oid.h
index 1704c27..a75f28b 100644
--- a/drivers/staging/rt2860/oid.h
+++ b/drivers/staging/rt2860/oid.h
@@ -87,7 +87,7 @@
 #define MAX_NUMBER_OF_DLS_ENTRY			4
 
 #define RT_QUERY_SIGNAL_CONTEXT				0x0402
-#define RT_SET_IAPP_PID                 	0x0404
+#define RT_SET_IAPP_PID				0x0404
 #define RT_SET_APD_PID						0x0405
 #define RT_SET_DEL_MAC_ENTRY				0x0406
 #define RT_QUERY_EVENT_TABLE			0x0407
-- 
1.7.2.3

