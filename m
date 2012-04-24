Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab2DXWi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:38:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891Ab2DXWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:53 -0400
Message-Id: <20120424223256.403094879@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 34/42] rt2800: Add support for the Fujitsu Stylistic Q550
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 3ac44670ad0fca8b6c43b3e4d8494c67c419f494 upstream.

Just another USB identifier.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1064,6 +1064,8 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x7392, 0x7722) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
+	/* Fujitsu Stylistic 550 */
+	{ USB_DEVICE(0x1690, 0x0761) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010) },
 	/* Gigabyte */


