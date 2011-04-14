Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab1DNSEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:04:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:42283 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab1DNR7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 185/209] USB: misc: uss720.c: add another vendor/product ID
Date: Thu, 14 Apr 2011 13:55:43 -0400
Message-Id: <1302803767-9715-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Sailer <t.sailer@alumni.ethz.ch>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit ecc1624a2fff45780959efbcb73ace18fdb3c58d upstream.

Fabio Battaglia report that he has another cable that works with this
driver, so this patch adds its vendor/product ID.

Signed-off-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/uss720.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 796e2f6..4ff2158 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -3,7 +3,7 @@
 /*
  *	uss720.c  --  USS720 USB Parport Cable.
  *
- *	Copyright (C) 1999, 2005
+ *	Copyright (C) 1999, 2005, 2010
  *	    Thomas Sailer (t.sailer@alumni.ethz.ch)
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -776,6 +776,8 @@ static const struct usb_device_id uss720_table[] = {
 	{ USB_DEVICE(0x0557, 0x2001) },
 	{ USB_DEVICE(0x0729, 0x1284) },
 	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x050d, 0x0002) },
 	{ }						/* Terminating entry */
 };
 
-- 
1.7.4.4

