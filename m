Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2BXTdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:33:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37817 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2BXTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:33:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.135.34 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 11:26:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224192643.GB24120@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
 <20120224191535.GA4505@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224191535.GA4505@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 08:15:35PM +0100, Henrik Rydberg wrote:
> > > Given the choice, I would be quite happy to piss off some robots. Call
> > > it a prejudice if you like ;).
> > 
> > You can't control how people use an interface.  You will note that there
> > are no stupid users of the UIO interface in the kernel today, we can't
> > control what people do in the privacy of their own companies/homes,
> > despite numerous governments trying to do so in the past.
> > 
> > So yes, people will always do stupid, foolish things.  And they were
> > doing them before UIO came along, now they just have the chance to at
> > least do those foolish things in a way that interfaces with the kernel
> > in a semi-sane manner, not messing anything else in the kernel up.
> 
> So the question is; can the uio example be repeated in other areas, to
> bring more kernel power to userspace?

What exactly do you mean by "more kernel power"?  You can write
userspace char drivers, filesystems, usb drivers, usb gadget drivers,
and lots of other things today with the interfaces we provide from the
kernel.

And even better yet, please show what you mean with patches.

greg k-h
