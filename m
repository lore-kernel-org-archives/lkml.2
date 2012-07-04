Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab2GDIOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:14:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41123 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab2GDIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:14:17 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Mark Grosen <mgrosen@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] remoteproc: fix missing CONFIG_FW_LOADER configurations
Date: Wed,  4 Jul 2012 11:14:04 +0300
Message-Id: <1341389644-12834-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remoteproc requires user space firmware loading support, so
let's select FW_LOADER explicitly to avoid painful misconfigurations
(which only show up in runtime).

Cc: stable <stable@vger.kernel.org>
Reported-by: Mark Grosen <mgrosen@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index db4e39b..f8d818a 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -4,6 +4,7 @@ menu "Remoteproc drivers (EXPERIMENTAL)"
 config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
+	select FW_CONFIG
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
-- 
1.7.9.5

