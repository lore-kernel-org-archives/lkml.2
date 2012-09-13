Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab2IMSEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:04:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34750 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab2IMSEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:04:10 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] remoteproc: Add dependency to HAS_DMA
Date: Thu, 13 Sep 2012 20:03:58 +0200
Message-Id: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Remoteproc relies on HAS_DMA, add this dependency in Kconfig.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
cc: linux-kernel@vger.kernel.org
cc: Rusty Russell <rusty@rustcorp.com.au>

 drivers/remoteproc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index f8d818a..e7d440c 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -4,6 +4,7 @@ menu "Remoteproc drivers (EXPERIMENTAL)"
 config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
+	depends on HAS_DMA
 	select FW_CONFIG
 
 config OMAP_REMOTEPROC
-- 
1.7.9.5

