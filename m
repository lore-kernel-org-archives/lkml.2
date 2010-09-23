Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0IWODT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:03:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab0IWODS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:03:18 -0400
Date: Thu, 23 Sep 2010 07:02:36 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-serial device driver
Message-ID: <20100923140236.GB31394@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in> <20100913154843.GA27496@suse.de> <20100914060649.M96376@admin-gateway.ncra.tifr.res.in> <20100914131925.GC375@suse.de> <20100922052107.M44650@admin-gateway.ncra.tifr.res.in> <20100922145607.GB26309@suse.de> <20100923100127.M64470@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923100127.M64470@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:45:52PM +0530, Raju Rameshwar Uprade wrote:
> > For what driver?
>  
> I am using pl2303.c ( USB to serial device driver ) to communicate to
> various devices connected in parallel using RS-485 interface card.

So your program is going to fail if you use a different hardware device?
That doesn't sound like a good idea.

> > > Kindly help me.I am facing the problem in separating the data bytes so
> > > that I can send the data bytes separately using usb_submit_urb.
> > 
> > It all depends on the driver you are using.  Why not do all of this from
> > userspace?  That way it works on any device you are talking to.
> 
> I want to write data twice :
> 
> 1. Only address byte and then 
> 2. Data bytes.

Again, do this in userspace.

> I am properly allocating memory for write_urb using kzalloc.When I write complete user
> buffer to the port, it send the data properly.
> 
> But when I try to write only address byte machine get hang.
> 
> I have attached the source file.

Sorry, I really don't know, you are on your own here.

good luck,

greg k-h
