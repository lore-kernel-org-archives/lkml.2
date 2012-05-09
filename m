Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab2EIFxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38872 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756099Ab2EIFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:12 -0400
Message-Id: <20120509055036.220030096@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 047/167] [PATCH] rt2800: Add support for the Fujitsu Stylistic Q550
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 3ac44670ad0fca8b6c43b3e4d8494c67c419f494 upstream.

Just another USB identifier.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3778763..7d1b6e4 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1159,6 +1159,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x7392, 0x7722) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
+	/* Fujitsu Stylistic 550 */
+	{ USB_DEVICE(0x1690, 0x0761) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010) },
 	/* Gigabyte */
-- 
1.7.10



