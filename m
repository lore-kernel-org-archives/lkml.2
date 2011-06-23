Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab1FWSLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:11:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:34595 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab1FWRgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jon Thomas <jthomas@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 124/247] sierra: add new ID for Airprime/Sierra USB IP modem
Date: Thu, 23 Jun 2011 13:33:12 -0400
Message-Id: <1308850515-15242-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Thomas <jthomas@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e1dc5157c574e7249dc1cd072fde2e48b3011533 upstream.

I picked up a new Sierra usb 308 (At&t Shockwave) on 2/2011 and the vendor code
is 0x0f3d

Looking up vendor and product id's I see:

0f3d  Airprime, Incorporated
 0112  CDMA 1xEVDO PC Card, PC 5220

Sierra and Airprime are somehow related and I'm guessing the At&t usb 308 might
be have some common hardware with the AirPrime SL809x.

Signed-off-by: Jon Thomas <jthomas@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/sierra.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index d47b56e..e3f32a4 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -301,6 +301,9 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
+	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
        { USB_DEVICE(0x413C, 0x08133) }, /* Dell Computer Corp. Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
 
 	{ }
-- 
1.7.4.4

