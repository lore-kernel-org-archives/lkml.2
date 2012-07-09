Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2GITZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:25:38 -0400
Received: from csmtp2.one.com ([91.198.169.22]:47326 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2GITZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:25:37 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Mon, 9 Jul 2012 21:25:29 +0200
To: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add MacBookPro10,1 support
Message-ID: <20120709192529.GA712@polaris.bitmath.org>
References: <1341856347-257-1-git-send-email-rydberg@euromail.se>
 <20120709184824.GA21411@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709184824.GA21411@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:48:24PM -0300, Johan Hedberg wrote:
> Hi Henrik,
> 
> On Mon, Jul 09, 2012, Henrik Rydberg wrote:
> > Add support for the 2012 15'' MacBook Pro Retina.
> > 
> > Patch originally written by clipcarl (forums.opensuse.org).
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi Gustavo,
> > 
> > This patch adds support for the new retina. Picked up from the suse
> > forum. Getting it into 3.5 would be great, if possible.
> > 
> > Cheers,
> > Henrik
> > 
> >  drivers/bluetooth/btusb.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> I believe the requirement is to always include a usb-devices output in
> the commit message (to let maintainers confirm that no typo has occurred
> in the patch itself).

A patch that has been tested is obviously an even stronger indication.
Hopefully the modification below will suffice.

Thanks,
Henrik

>From 63bc0de5b431ca616557d87869f41ee22fdc5906 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Mon, 9 Jul 2012 13:32:49 +0200
Subject: [PATCH] Bluetooth: Add MacBookPro10,1 support

Add support for the 2012 15'' MacBook Pro Retina, also known as
MacBookPro10,1. The bluetooth device presents itself as

Bus 002 Device 008: ID 05ac:8286 Apple, Inc. 

Patch originally written and tested by clipcarl (forums.opensuse.org).

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 83ebb24..6cc54da 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -84,6 +84,9 @@ static struct usb_device_id btusb_table[] = {
 	/* Apple MacMini5,1 */
 	{ USB_DEVICE(0x05ac, 0x8281) },
 
+	/* Apple MacBookPro10,1 */
+	{ USB_DEVICE(0x05ac, 0x8286) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 
-- 
1.7.11.1

