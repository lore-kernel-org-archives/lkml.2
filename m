Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0HCRDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:03:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:42409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab0HCRDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:03:10 -0400
Date: Tue, 3 Aug 2010 09:38:26 -0700
From: Greg KH <gregkh@suse.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        nm127@freemail.hu, linux-kernel@vger.kernel.org, maxinbjohn@gmail.com,
        forest.bond@outpostembedded.com, vijaykumar@zilogic.com
Subject: Re: [PATCH] USB-serial dummy cable driver
Message-ID: <20100803163826.GA757@suse.de>
References: <1280728807-20296-1-git-send-email-marek.vasut@gmail.com>
 <20100802224718.GC28821@suse.de>
 <201008031814.15859.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201008031814.15859.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 06:14:15PM +0200, Marek Vasut wrote:
> Dne Út 3. srpna 2010 00:47:18 Greg KH napsal(a):
> > On Mon, Aug 02, 2010 at 08:00:07AM +0200, Marek Vasut wrote:
> > > This driver is used to implement USB-serial like behaviour over dummy
> > > 
> > > USB cables. These are used in the following devices:
> > > 	Funsoft Serial USB driver
> > > 	Genesys Logic GL620USB USB Laplink cable
> > > 	HP4x (48/49) Serial cable
> > > 	Motorola phones
> > > 	Siemens USB-MPI Serial USB driver
> > > 	ViVOpay USB Serial Driver
> > > 	ZIO Motherboard USB driver
> > 
> > I like the idea, but not the name :)
> 
> Please don't expect miracles from me after 26 hours without sleep ;-)
> > 
> > Ideally, all of these would be able to be handled by the usb-serial
> > generic driver directly.
> 
> I just noticed that one. Stupid me.
> > 
> > But really, having these multiple drivers is a good thing, they properly
> > convey to the user what the device is, and it gives these developers and
> > companies a sense of ownership over the code, and that matters at times.
> > 
> > So you lost the names of the devices with this patch, which isn't good.
> 
> Sheesh ... that's true, but having pile of copies of the same code is not good 
> either.

I agree, that's why I said it should be reduced.

> Can't we then just deprecate all these drivers and set correct udev
> rules?

udev can not change the name of the device in sysfs, or the name in the
kernel of the device.

thanks,

greg k-h
