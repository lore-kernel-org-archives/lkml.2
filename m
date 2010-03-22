Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0CVXaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 19:30:07 -0400
Received: from mini002.webpack.hosteurope.de ([80.237.130.131]:52514 "EHLO
	mini002.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755113Ab0CVXaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 19:30:04 -0400
X-Greylist: delayed 1328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Mar 2010 19:30:04 EDT
Date: Tue, 23 Mar 2010 00:07:46 +0100
From: Andreas Hartmann <andi@ahash.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kaweth: New USB ID 07c9:b010 Allied Telesyn AT-USB10
Message-ID: <20100323000746.65aaa3db@zed>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;andi@ahash.de;1269300604;044b3b93;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New USB ID 07c9:b010 Allied Telesyn AT-USB10
Signed-off-by: Andreas Hartmann <andi@ahash.de>
---
This USB Ethernet adapter has the KL5KUSB101B chip and is so far unknown to the
kaweth driver. The device was found working with the patch applied.
--- linux-2.6.34-rc2/drivers/net/usb/kaweth.c.orig      2010-03-20 02:17:57.000000000 +0100
+++ linux-2.6.34-rc2/drivers/net/usb/kaweth.c   2010-03-22 23:30:31.000000000 +0100
@@ -145,6 +145,7 @@ static struct usb_device_id usb_klsi_tab
        { USB_DEVICE(0x0707, 0x0100) }, /* SMC 2202USB */
        { USB_DEVICE(0x07aa, 0x0001) }, /* Correga K.K. */
        { USB_DEVICE(0x07b8, 0x4000) }, /* D-Link DU-E10 */
+       { USB_DEVICE(0x07c9, 0xb010) }, /* Allied Telesyn AT-USB10 */
        { USB_DEVICE(0x0846, 0x1001) }, /* NetGear EA-101 */
        { USB_DEVICE(0x0846, 0x1002) }, /* NetGear EA-101 */
        { USB_DEVICE(0x085a, 0x0008) }, /* PortGear Ethernet Adapter */
