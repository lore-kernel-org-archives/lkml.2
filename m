Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1EKQTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:19:15 -0400
Received: from kroah.org ([198.145.64.141]:35357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483Ab1EKQTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:02 -0400
Date: Wed, 11 May 2011 06:51:14 -0700
From: Greg KH <greg@kroah.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Message-ID: <20110511135114.GD12717@kroah.com>
References: <201104201358.50443.jasonbstubbs@gmail.com>
 <201104281855.50572.jasonbstubbs@gmail.com>
 <20110510223908.GA16989@kroah.com>
 <201105111447.49816.jasonbstubbs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105111447.49816.jasonbstubbs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 02:47:49PM +1000, Jason Stubbs wrote:
> On Wed, 11 May 2011 08:39:08 Greg KH wrote:
> > On Thu, Apr 28, 2011 at 06:55:50PM +1000, Jason Stubbs wrote:
> > > Not sure of the "bump" process, so I'll just go over each part of the
> > > patch.
> > > 
> > > Note that all the changes only affect the sabi_config where
> > > min_brightness is 1 so you might not see in difference on your hardware.
> > 
> > This isn't needed anymore due to your other patch superseeding it,
> > right?
> 
> Actually, this one is irrelevant to the nc210/nc110 support as that laptop 
> uses the "SwSmi@" sabi. It was just something I noticed while learning the 
> code. The miscalculations will only affect any laptops that use the "SECLINUX" 
> sabi but I tested it by setting min_brightness to 2 for my laptop.

That's wierd, as that is the type of laptop I have here and it seems to
work just fine for me as-is.

> The patch doesn't apply cleanly on top of the nc210/nc110 patch though as they 
> both modify set_brightness(). It might apply with a higher fuzz factor as the 
> changes don't actually clash. Should I redo the patch?

Please do.

thanks,

greg k-h
