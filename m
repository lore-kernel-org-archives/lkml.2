Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1LULWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:22:22 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37959 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1LULWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:22:20 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Rob Clark <rob@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Subject: [PATCH 2/2] rpmsg: depend on EXPERIMENTAL
Date: Wed, 21 Dec 2011 13:21:13 +0200
Message-Id: <1324466473-5128-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1324466473-5128-1-git-send-email-ohad@wizery.com>
References: <1324466473-5128-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't any binary change in sight or evidence of any stability
issue, but as we just begin to get traction we can't rule them out
completely.

To be on the safe side, let's mark rpmsg as EXPERIMENTAL, and remove
it later on after we have several happy users.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Clark <rob@ti.com>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
---
 drivers/rpmsg/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
index 98aca55..32aead6 100644
--- a/drivers/rpmsg/Kconfig
+++ b/drivers/rpmsg/Kconfig
@@ -1,9 +1,10 @@
-menu "Rpmsg drivers"
+menu "Rpmsg drivers (EXPERIMENTAL)"
 
 # RPMSG always gets selected by whoever wants it
 config RPMSG
 	tristate
 	select VIRTIO
 	select VIRTIO_RING
+	depends on EXPERIMENTAL
 
 endmenu
-- 
1.7.5.4

