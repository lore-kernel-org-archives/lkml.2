Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100Ab1FWR4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:56:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:35162 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629Ab1FWRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, wangyanqing <udknight@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 182/247] USB: serial: ch341: add new id
Date: Thu, 23 Jun 2011 13:34:10 -0400
Message-Id: <1308850515-15242-123-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wangyanqing <udknight@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d0781383038e983a63843a9a6a067ed781db89c1 upstream.

I picked up a new DAK-780EX(professional digitl reverb/mix system),
which use CH341T chipset to communication with computer on 3/2011
and the CH341T's vendor code is 1a86

Looking up the CH341T's vendor and product id's I see:

1a86  QinHeng Electronics
  5523  CH341 in serial mode, usb to serial port converter

CH341T,CH341 are the products of the same company, maybe
have some common hardware, and I test the ch341.c works
well with CH341T

Cc: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ch341.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index c467850..a1c9625 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -75,6 +75,7 @@ static int debug;
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
-- 
1.7.4.4

