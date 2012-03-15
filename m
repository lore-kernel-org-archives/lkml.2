Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068Ab2COS4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:56:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41244 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762033Ab2COS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:56:52 -0400
Date: Thu, 15 Mar 2012 11:56:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
Message-ID: <20120315185648.GC11142@kroah.com>
References: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
 <20120315093331.6472333e@lembas.zaitcev.lan>
 <20120315153747.GA23515@kroah.com>
 <20120315181045.GB5702@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315181045.GB5702@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 07:10:45PM +0100, Sebastian Andrzej Siewior wrote:
> > > Although the above is false, and ub actually started libusual,
> > > I don't mind. It's a transient notice anyway. Once ub is gone,
> > > libusual can be folded back into usb-storage.
> > 
> > Good point.
> > 
> > Sebastian, care to reword this and resend it?
> I want clarify one thing but sure.
> 
> > Also, are you going to be doing the "merge libusual into usb-storage"
> > after you remove the ub driver?
> 
> This sounds like once ub is out, you have to merge those two :) So yes, unless
> a use case for it comes up.

I'll take patches from you to do this, as the removal patch of ub will
make libusual not need to be stand-alone.

And you will be the one sending the ub removal patch in 6 months, right?

thanks,

greg k-h
