Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab2CVRnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:43:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40885 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2CVRnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:43:06 -0400
From: Michael BRIGHT <mjbrightfr@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michael BRIGHT <mjbrightfr+git-kernel@gmail.com>
Subject: [PATCH 1/1] USB: remove compile warning on gadget/inode.c
Date: Thu, 22 Mar 2012 18:42:52 +0100
Message-Id: <1332438172-20215-1-git-send-email-mjbrightfr+git-kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused "restart:" label, which was causing compiler warning.

Signed-off-by: Michael BRIGHT <mjbrightfr+git-kernel@gmail.com>
---
 drivers/usb/gadget/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 8793f32..e58b164 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1574,7 +1574,6 @@ static void destroy_ep_files (struct dev_data *dev)
 	DBG (dev, "%s %d\n", __func__, dev->state);
 
 	/* dev->state must prevent interference */
-restart:
 	spin_lock_irq (&dev->lock);
 	while (!list_empty(&dev->epfiles)) {
 		struct ep_data	*ep;
-- 
1.7.9.1

