Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1LNLuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:50:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51439 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948Ab1LNLtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:39 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 7/7] rpmsg: add Kconfig menu
Date: Wed, 14 Dec 2011 13:48:35 +0200
Message-Id: <1323863315-8159-8-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dedicated Kconfig menu for the rpmsg drivers, so they
don't show up in the main driver menu.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/rpmsg/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
index 811fede..98aca55 100644
--- a/drivers/rpmsg/Kconfig
+++ b/drivers/rpmsg/Kconfig
@@ -1,5 +1,9 @@
+menu "Rpmsg drivers"
+
 # RPMSG always gets selected by whoever wants it
 config RPMSG
 	tristate
 	select VIRTIO
 	select VIRTIO_RING
+
+endmenu
-- 
1.7.5.4

