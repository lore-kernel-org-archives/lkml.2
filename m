Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765Ab2EOCnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:43:47 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53468 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250Ab2EOCRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 119/179] USB: pl2303.h: checkpatch cleanups
Date: Mon, 14 May 2012 22:13:35 -0400
Message-ID: <1337048075-6132-120-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5d78fcb0caf219e2e6c8e486d7e31fec1333ac06 upstream.

Minor whitespace cleanups to make checkpatch happy.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/pl2303.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index d67b480..1b025f7 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -5,7 +5,7 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- * 
+ *
  */
 
 #define BENQ_VENDOR_ID			0x04a5
@@ -142,5 +142,5 @@
 #define SANWA_PRODUCT_ID	0x0001
 
 /* ADLINK ND-6530 RS232,RS485 and RS422 adapter */
-#define ADLINK_VENDOR_ID        0x0b63
-#define ADLINK_ND6530_PRODUCT_ID       0x6530
+#define ADLINK_VENDOR_ID		0x0b63
+#define ADLINK_ND6530_PRODUCT_ID	0x6530
-- 
1.7.9.6

