Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030940Ab2COPhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:37:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58123 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030469Ab2COPhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:37:51 -0400
Date: Thu, 15 Mar 2012 08:37:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
Message-ID: <20120315153747.GA23515@kroah.com>
References: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
 <20120315093331.6472333e@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315093331.6472333e@lembas.zaitcev.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:33:31AM -0600, Pete Zaitcev wrote:
> On Wed, 14 Mar 2012 21:52:51 +0100
> Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
> 
> > +What:	Low Performance USB Block driver ("CONFIG_BLK_DEV_UB")
> > +When:	3.6
> 
> ACK
> 
> > +	does not use libusual which holds various workarounds for
> > +	certain buggy devices.
> 
> Although the above is false, and ub actually started libusual,
> I don't mind. It's a transient notice anyway. Once ub is gone,
> libusual can be folded back into usb-storage.

Good point.

Sebastian, care to reword this and resend it?

Also, are you going to be doing the "merge libusual into usb-storage"
after you remove the ub driver?

thanks,

greg k-h
