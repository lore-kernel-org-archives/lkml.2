Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0JSR5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:57:10 -0400
Received: from kroah.org ([198.145.64.141]:52482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab0JSR5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:57:08 -0400
Date: Tue, 19 Oct 2010 10:50:36 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 2/3] usb: trivial Kconfig cleanups
Message-ID: <20101019175036.GB4618@kroah.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
 <1287482608-11320-3-git-send-email-felipe.contreras@gmail.com>
 <20101019155109.GH4589@kroah.com>
 <AANLkTi=CzBriAFW2gzG68b=6wENysJZEkaO9jFrXQdnq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=CzBriAFW2gzG68b=6wENysJZEkaO9jFrXQdnq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 08:15:19PM +0300, Felipe Contreras wrote:
> On Tue, Oct 19, 2010 at 6:51 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Oct 19, 2010 at 01:03:27PM +0300, Felipe Contreras wrote:
> >> Note: USB_GADGET_MUSB_HDRC is already defined in usb/gadget.
> >>
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >
> > Please describe _what_ trivial cleanups you did, and why you did them.
> > Care to resend?
> 
> How about:
> Shuffle the code a bit so the description is at the top, remove
> duplicated configs (USB_GADGET_MUSB_HDRC),  'default n' is redundant,
> and USB_GADGET_SELECTED should go after USB_GADGET (on the appropriate
> config).

Sounds good, but you need to resend it with this information in it, not
much I can do with it in an independant email.

thanks,

greg k-h
