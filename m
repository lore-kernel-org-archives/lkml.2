Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1AGTQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:16:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:34433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1AGTQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:16:51 -0500
Date: Fri, 7 Jan 2011 11:09:38 -0800
From: Greg KH <gregkh@suse.de>
To: Richard =?iso-8859-1?Q?Sch=FCtz?= <r.schtz@t-online.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergey Vlasov <vsu@altlinux.ru>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [PATCH v2] USB: usb-storage: unusual_devs update for Cypress
 ATACB
Message-ID: <20110107190938.GA15693@suse.de>
References: <4D11FBEF.7040101@t-online.de>
 <4D2701F7.5090503@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D2701F7.5090503@t-online.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 01:07:19PM +0100, Richard Schütz wrote:
> >Added new device ID for unusual Cypress ATACB device.
> >
> >Signed-off-by: Richard Schütz <r.schtz@t-online.de>
> >---
> >
> >Applies to 2.6.37-rc7 now.
> >
> >--- a/drivers/usb/storage/unusual_cypress.h 2010-12-21 20:26:40.000000000 +0100
> >+++ b/drivers/usb/storage/unusual_cypress.h 2010-12-22 12:38:49.013825668 +0100
> >@@ -31,4 +31,9 @@ UNUSUAL_DEV( 0x04b4, 0x6831, 0x0000, 0x
> >"Cypress ISD-300LP",
> >USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
> >
> >+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
> >+ "Super Top",
> >+ "USB 2.0 SATA BRIDGE",
> >+ USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
> >+
> >#endif /* defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || ... */
> >
> 
> Why was this simple patch not accepted (yet)? Is something wrong with it?
> 
> Discussion was here:
> http://thread.gmane.org/gmane.linux.usb.general/40545
> http://thread.gmane.org/gmane.linux.usb.general/40550

Nothing's wrong with it.  You just sent it at the start of the 2 week
holiday vacation, and I will get to it after the .38-rc1 release is out
and get it to Linus after that.

It's still in my "to-apply" queue.

thanks for your patience,

greg k-h
