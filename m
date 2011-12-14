Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab1LNLt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:49:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab1LNLth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:37 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 6/7] remoteproc: add Kconfig menu
Date: Wed, 14 Dec 2011 13:48:34 +0200
Message-Id: <1323863315-8159-7-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dedicated Kconfig menu for the remoteproc drivers, so they
don't show up in the main driver menu.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 396c97a..00fb72f 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -1,3 +1,5 @@
+menu "Remoteproc drivers"
+
 # REMOTEPROC gets selected by whoever wants it
 config REMOTEPROC
 	tristate
@@ -22,3 +24,5 @@ config OMAP_REMOTEPROC
 
 	  It's safe to say n here if you're not interested in multimedia
 	  offloading or just want a bare minimum kernel.
+
+endmenu
-- 
1.7.5.4

