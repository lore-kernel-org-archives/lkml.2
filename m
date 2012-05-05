Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2EEOdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33050 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2EEOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:31 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 6/8] drivers/staging/line6/midibuf.c changed printk(KERN_DEBUG, ... to pr_debug(
Date: Sat,  5 May 2012 16:31:50 +0200
Message-Id: <1336228312-5379-7-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed printk(KERN_DEBUG, ...) call to pr_debug call in function
void line6_midibuf_status(struct MidiBuffer *this)

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/midibuf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/midibuf.c b/drivers/staging/line6/midibuf.c
index 7b532e5..836e8c8 100644
--- a/drivers/staging/line6/midibuf.c
+++ b/drivers/staging/line6/midibuf.c
@@ -64,7 +64,7 @@ int line6_midibuf_init(struct MidiBuffer *this, int size, int split)
 
 void line6_midibuf_status(struct MidiBuffer *this)
 {
-	printk(KERN_DEBUG "midibuf size=%d split=%d pos_read=%d pos_write=%d "
+	pr_debug("midibuf size=%d split=%d pos_read=%d pos_write=%d "
 	       "full=%d command_prev=%02x\n", this->size, this->split,
 	       this->pos_read, this->pos_write, this->full, this->command_prev);
 }
-- 
1.7.7.6

