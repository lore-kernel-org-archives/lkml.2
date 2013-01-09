Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab3AIMSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:18:40 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64123 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3AIMSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:18:39 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH char-misc-next] mei: Fix some more kernel-doc typos in hw-me.c
Date: Wed,  9 Jan 2013 13:18:24 +0100
Message-Id: <1357733904-18304-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/misc/mei/hw-me.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 93a2a56..94b203e 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -236,7 +236,7 @@ irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
 /**
  * mei_hbuf_filled_slots - gets number of device filled buffer slots
  *
- * @device: the device structure
+ * @dev: the device structure
  *
  * returns number of filled slots
  */
@@ -289,7 +289,7 @@ int mei_hbuf_empty_slots(struct mei_device *dev)
  * mei_write_message - writes a message to mei device.
  *
  * @dev: the device structure
- * @hader: mei HECI header of message
+ * @header: mei HECI header of message
  * @buf: message payload will be written
  *
  * This function returns -EIO if write has failed
-- 
1.7.9.5

