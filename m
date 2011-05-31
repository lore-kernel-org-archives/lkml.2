Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1EaWA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:00:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59805 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab1EaWA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:00:28 -0400
From: Niels de Vos <ndevos@redhat.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Niels de Vos <ndevos@redhat.com>
Subject: [PATCH] ehci-hcd: remove EOL from MODULE_PARM_DESC for 'hird' option
Date: Tue, 31 May 2011 23:00:10 +0100
Message-Id: <1306879210-4988-1-git-send-email-ndevos@redhat.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have a "\n" on a MODULE_PARM_DESC, remove it

Signed-off-by: Niels de Vos <ndevos@redhat.com>
---
 drivers/usb/host/ehci-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b435ed6..e18862c 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -110,7 +110,7 @@ MODULE_PARM_DESC (ignore_oc, "ignore bogus hardware overcurrent indications");
 /* for link power management(LPM) feature */
 static unsigned int hird;
 module_param(hird, int, S_IRUGO);
-MODULE_PARM_DESC(hird, "host initiated resume duration, +1 for each 75us\n");
+MODULE_PARM_DESC(hird, "host initiated resume duration, +1 for each 75us");
 
 #define	INTR_MASK (STS_IAA | STS_FATAL | STS_PCD | STS_ERR | STS_INT)
 
-- 
1.7.4.4

