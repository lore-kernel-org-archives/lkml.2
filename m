Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0DXPQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 11:16:46 -0400
Received: from kroah.org ([198.145.64.141]:57122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab0DXPQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 11:16:45 -0400
Date: Sat, 24 Apr 2010 08:17:16 -0700
From: Greg KH <greg@kroah.com>
To: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core
	internal headers
Message-ID: <20100424151716.GD10840@kroah.com>
References: <Pine.LNX.4.44L0.1004231402180.1777-100000@iolanthe.rowland.org> <4BD24841.1010206@VirtualLogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD24841.1010206@VirtualLogix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 03:24:17AM +0200, Eric Lescouet wrote:
> On 04/23/2010 08:04 PM, Alan Stern wrote:
> > On Fri, 23 Apr 2010, Eric Lescouet wrote:
> > 
> >> Well, most of the files include hcd.h (which includes hub.h),
> >> only ~4 of them directly use hub.h.
> > 
> > Oh.  Okay, that makes life easier.  Probably some of the files which 
> > include hub.h directly also include hcd.h.
> > 
> >> So what's your vote? rename hub.h into ch11.h?
> > 
> > Yeah, go ahead.  I like the idea of the kernel containing information 
> > about Chapter 11.  (Although I haven't heard of anyone yet going 
> > bankrupt as a result of using Linux...)
> > 
> > Alan Stern
> > 
> 
> It looks like couple of files in drivers/usb/core and usb/host have been
> modified already in latest snapshot (2.6.34-rc5-git5).
> Is it still ok to provide the patches against the mainline (2.6.34-rc5)
> or should I do it against the snapshot (2.6.34-rc5-git5)?

The latest snapshot is best.

thanks,

greg k-h
