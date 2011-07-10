Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1GJJ2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:28:42 -0400
Received: from mail.perches.com ([173.55.12.10]:3730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab1GJJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:28:36 -0400
From: Joe Perches <joe@perches.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case
Date: Sun, 10 Jul 2011 02:28:27 -0700
Message-Id: <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1310289795.git.joe@perches.com>
References: <cover.1310289795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/gadget/fusb300_udc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 06353e7..453bc0f 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -688,10 +688,13 @@ static void fusb300_cmp_dbg_fifo(struct fusb300_ep *ep,
 	switch (length % 4) {
 	case 1:
 		golden_value = *tmp;
+		break;
 	case 2:
 		golden_value = *tmp | *(tmp + 1) << 8;
+		break;
 	case 3:
 		golden_value = *tmp | *(tmp + 1) << 8 | *(tmp + 2) << 16;
+		break;
 	default:
 		break;
 
-- 
1.7.6.131.g99019

