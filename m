Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0KGVOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:14:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0KGVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:14:50 -0500
From: Stefan Weil <weil@mail.berlios.de>
Cc: Stefan Weil <weil@mail.berlios.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling in MODULE_ALIAS
Date: Sun,  7 Nov 2010 22:14:31 +0100
Message-Id: <1289164471-9080-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:nijqanWuNVs45ZoP6ST2c+jfSyHAvA43wgRqmWGRwU3
 A4l5Lk+49OPHJ1gvv0FkcmvqfS+9M5UtLStV1PlsV8aZJkuWOc
 QKlN3mVgQngamcu2XK7IbgnVNiVda+9QYt+ySHBmSXoBWVXlo8
 j9Uj+5rz4r0oQVmT7pg7k7fBfhvAc90z1ELQ62phOg2T0RIDbr
 W8fKlgksW73fN7Y8pvBAZYS4g+gv+WfwE6MwLVdfmh/8YfyfhB
 eb8FlRCSvdJoo
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platfrom -> platform

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/usb/host/ohci-jz4740.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ohci-jz4740.c b/drivers/usb/host/ohci-jz4740.c
index 10e1872..931d588 100644
--- a/drivers/usb/host/ohci-jz4740.c
+++ b/drivers/usb/host/ohci-jz4740.c
@@ -273,4 +273,4 @@ static struct platform_driver ohci_hcd_jz4740_driver = {
 	},
 };
 
-MODULE_ALIAS("platfrom:jz4740-ohci");
+MODULE_ALIAS("platform:jz4740-ohci");
-- 
1.7.2.3

