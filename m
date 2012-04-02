Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2DBQYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:24:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56962 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2DBQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:24:51 -0400
Date: Mon, 2 Apr 2012 09:24:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Tuttle <ttuttle@chromium.org>
Subject: Re: [ 032/149] USB: qcserial: add several new serial devices
Message-ID: <20120402162446.GB10138@kroah.com>
References: <20120330194840.189874097@linuxfoundation.org>
 <1333296015.3500.367.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333296015.3500.367.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 05:00:15PM +0100, Ben Hutchings wrote:
> On Fri, 2012-03-30 at 12:49 -0700, Greg KH wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Thomas Tuttle <ttuttle@chromium.org>
> > 
> > commit 2db4d87070e87d198ab630e66a898b45eff316d9 upstream.
> > 
> > Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/usb/serial/qcserial.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > --- a/drivers/usb/serial/qcserial.c
> > +++ b/drivers/usb/serial/qcserial.c
> > @@ -36,6 +36,11 @@ static const struct usb_device_id id_tab
> >  	{USB_DEVICE(0x413c, 0x8171)},	/* Dell Gobi QDL device */
> >  	{USB_DEVICE(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
> >  	{USB_DEVICE(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
> > +	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi QDL device */
> [...]
> 
> This one is already claimed by option as:
> 
> 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) }
> 
> Seems there's some confusion here...

Yes, but that's what is in Linus's tree right now, right?

One of them should be removed, but I don't know which one :(

thanks,

greg k-h
