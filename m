Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2HOTwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:45 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63111 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab2HOTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: sordna <sordna@gmail.com>, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 140/165] USB: quirks: adding more quirky webcams to avoid squeaky audio
Date: Wed, 15 Aug 2012 15:48:04 -0400
Message-ID: <1345060109-9187-141-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sordna <sordna@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0d145d7d4a241c321c832a810bb6edad18e2217b upstream.

The following patch contains additional affected webcam models, on top of the
patches commited to linux-next 2394d67e446bf616a0885167d5f0d397bdacfdfc
and 5b253d88cc6c65a23cefc457a5a4ef139913c5fc

Signed-off-by: sordna <sordna@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/quirks.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f1b7442..9774dfc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -53,12 +53,36 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Logitech Webcam Pro 9000 */
 	{ USB_DEVICE(0x046d, 0x0809), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Webcam C905 */
+	{ USB_DEVICE(0x046d, 0x080a), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C210 */
+	{ USB_DEVICE(0x046d, 0x0819), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C260 */
+	{ USB_DEVICE(0x046d, 0x081a), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Webcam C310 */
 	{ USB_DEVICE(0x046d, 0x081b), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Webcam C910 */
+	{ USB_DEVICE(0x046d, 0x0821), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Webcam C160 */
+	{ USB_DEVICE(0x046d, 0x0824), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Webcam C270 */
 	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Logitech Quickcam Pro 9000 */
+	{ USB_DEVICE(0x046d, 0x0990), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Quickcam E3500 */
+	{ USB_DEVICE(0x046d, 0x09a4), .driver_info = USB_QUIRK_RESET_RESUME },
+
+	/* Logitech Quickcam Vision Pro */
+	{ USB_DEVICE(0x046d, 0x09a6), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Philips PSC805 audio device */
 	{ USB_DEVICE(0x0471, 0x0155), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.7.12.rc2

