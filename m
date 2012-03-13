Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2CMASU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:18:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:46845 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2CMASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:18:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Marc-Antoine Perennou <Marc-Antoine@perennou.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 037/196] Bluetooth: add support for Apple MacBook Pro 8,2
Date: Mon, 12 Mar 2012 20:12:45 -0400
Message-Id: <1331597724-31358-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 63a8588debd4dc72becb9e27add9343c76301c7d upstream.

Just adding the vendor details makes it work fine.

Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6fcb971..c9e2dc8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -62,6 +62,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple iMac11,1 */
 	{ USB_DEVICE(0x05ac, 0x8215) },
 
+	/* Apple MacBookPro8,2 */
+	{ USB_DEVICE(0x05ac, 0x821a) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 
-- 
1.7.9.3

