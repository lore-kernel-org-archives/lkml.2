Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462Ab0HMN5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:57:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43385 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934402Ab0HMN4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:56:25 -0400
From: raja_mani@ti.com
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, pavan_savoy@sify.com, Raja-Mani <x0102026@ti.com>,
        Pramodh AG <pramodh_ag@ti.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH/RFC 6/6] Staging: ti-st: Add TODO file for FM
Date: Fri, 13 Aug 2010 10:14:44 -0400
Message-Id: <1281708884-15462-7-git-send-email-raja_mani@ti.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1281708884-15462-6-git-send-email-raja_mani@ti.com>
References: <1281708884-15462-1-git-send-email-raja_mani@ti.com>
 <1281708884-15462-2-git-send-email-raja_mani@ti.com>
 <1281708884-15462-3-git-send-email-raja_mani@ti.com>
 <1281708884-15462-4-git-send-email-raja_mani@ti.com>
 <1281708884-15462-5-git-send-email-raja_mani@ti.com>
 <1281708884-15462-6-git-send-email-raja_mani@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja-Mani <x0102026@ti.com>

fm_TODO file lists the things to be done in FM driver.

Signed-off-by: Raja-Mani <x0102026@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/fm_TODO |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/fm_TODO

diff --git a/drivers/staging/ti-st/fm_TODO b/drivers/staging/ti-st/fm_TODO
new file mode 100644
index 0000000..0b36db0
--- /dev/null
+++ b/drivers/staging/ti-st/fm_TODO
@@ -0,0 +1,16 @@
+FM-TODO:
+
+01. Support FM TX functionality
+
+02. Support FM TX features like set/get region, set/get RSSI threshold,
+    and set/get AF switch state
+
+03. Step up and maintain this driver to ensure that it continues to work.
+    Having the hardware for this is pretty much a requirement.
+
+    If this does not happen, the driver will be removed in the 2.6.35 kernel
+    release.
+
+    Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
+    inux-media list <linux-media@vger.kernel.org>.
+
-- 
1.5.6.3

