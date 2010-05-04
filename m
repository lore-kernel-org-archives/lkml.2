Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab0EDQGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:06:04 -0400
Received: from kroah.org ([198.145.64.141]:41192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab0EDQF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:05:59 -0400
Date: Tue, 4 May 2010 08:49:14 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: adam.latham@unisontorbay.org.uk, devel@driverdev.osuosl.org,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Elwell <Andrew.Elwell@gmail.com>, linux-kernel@vger.kernel.org,
       Svenne Krap <svenne@krap.dk>
Subject: Re: Patch for wlan-ng/hfa384x_usb.c
Message-ID: <20100504154914.GA24737@kroah.com>
References: <1272911432.1902.1.camel@ubuntu.ubuntu-domain>
 <1272915210.30040.164.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272915210.30040.164.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 12:33:30PM -0700, Joe Perches wrote:
> On Mon, 2010-05-03 at 19:30 +0100, Adam Latham wrote:
> > Subject: [PATCH] Staging: wlan-ng: fix various whitespace and 80 char issues in hfa384x_usb.c
> > This is a patch to fix various whitespace and 80 character style issues found by checkpatch.pl tool
> > Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>
> 
> Hi Adam.
> 
> > diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
> > index 5df56f0..b7a319f 100644
> > --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> > +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> []
> > @@ -451,7 +451,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
> >  	if (test_bit(WORK_RX_HALT, &hw->usb_flags)) {
> >  		int ret;
> >  
> > -		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock! */
> > +		usb_kill_urb(&hw->rx_urb);	/* Cannot be holding spinlock!*/
> 
> It's most common to use a space before the trailing */

Yes, move the comment up a line to fix the "line too long" issue.

> > @@ -2619,7 +2619,7 @@ int hfa384x_drvr_start(hfa384x_t *hw)
> >  			pr_debug("First cmd_initialize() failed (result %d),\n",
> >  				 result1);
> >  			pr_debug
> > -			    ("but second attempt succeeded. All should be ok\n");
> > +			    ("but second attempt succeeded.All should be ok\n");
> 
> Removing the space after a period here is not an improvement.

Agreed, don't worry about too-long lines in print statements.

thanks,

greg k-h
