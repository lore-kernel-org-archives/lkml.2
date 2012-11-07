Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2KGBHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:07:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:54136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab2KGBHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:07:50 -0500
Message-ID: <5099B45E.8080105@infradead.org>
Date: Tue, 06 Nov 2012 17:07:42 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
CC: Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: fix input-mt kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warning in input-mt.c:

Warning(drivers/input/input-mt.c:38): No description found for parameter 'flags'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Henrik Rydberg <rydberg@euromail.se>
Cc:	linux-input@vger.kernel.org
---
 drivers/input/input-mt.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-37-rc4.orig/drivers/input/input-mt.c
+++ lnx-37-rc4/drivers/input/input-mt.c
@@ -26,6 +26,7 @@ static void copy_abs(struct input_dev *d
  * input_mt_init_slots() - initialize MT input slots
  * @dev: input device supporting MT events and finger tracking
  * @num_slots: number of slots used by the device
+ * @flags: device flags (see include/linux/input/mt.h)
  *
  * This function allocates all necessary memory for MT slot handling
  * in the input device, prepares the ABS_MT_SLOT and
