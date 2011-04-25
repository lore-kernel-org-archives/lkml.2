Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab1DYUj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:39:57 -0400
Received: from 1wt.eu ([62.212.114.60]:34409 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab1DYUY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:58 -0400
Message-Id: <20110425200238.858383776@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 135/173] Bluetooth: add support for Apple MacBook Pro 8,2
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>

commit 63a8588debd4dc72becb9e27add9343c76301c7d upstream.

Just adding the vendor details makes it work fine.

Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -62,6 +62,9 @@ static struct usb_device_id btusb_table[
 	/* Apple iMac11,1 */
 	{ USB_DEVICE(0x05ac, 0x8215) },
 
+	/* Apple MacBookPro8,2 */
+	{ USB_DEVICE(0x05ac, 0x821a) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 


