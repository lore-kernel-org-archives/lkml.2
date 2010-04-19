Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0DSQ0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:26:36 -0400
Received: from kroah.org ([198.145.64.141]:43114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab0DSQ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:26:30 -0400
Date: Mon, 19 Apr 2010 09:17:05 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Assmann <sassmann@redhat.com>, digidietze@draisberghof.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: expose Huawei E1550 3G modem
Message-ID: <20100419161705.GA28020@kroah.com>
References: <4BCC5071.4010509@redhat.com>
 <4BCC6206.4030003@draisberghof.de>
 <4BCC63EB.4010204@redhat.com>
 <20100419141907.GN26130@one-eyed-alien.net>
 <4BCC6FAF.2030809@redhat.com>
 <20100419161406.GO26130@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419161406.GO26130@one-eyed-alien.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 09:14:06AM -0700, Matthew Dharm wrote:
> On Mon, Apr 19, 2010 at 04:58:55PM +0200, Stefan Assmann wrote:
> > On 19.04.2010 16:19, Matthew Dharm wrote:
> > > 
> > > 2) It is much much easier to update a userspace tool than the kernel.
> > > Thus, new devices can be supported without a kernel update by end-users.
> > 
> > Of course. Nobody is talking about removing existing code from any
> > user-space application. Under the condition that no functionality gets
> > lost, wouldn't it be convenient to have the modem exposed by the kernel?
> > If the kernel support doesn't suffice you can still run an updated
> > usb_modeswitch until kernel support is there.
> > 
> > This also has the benefit that it would work for people that don't
> > have usb_modeswitch installed. Matt, are you still thinking that is the
> > wrong way of doing it?
> 
> I still believe that, for an end-user, upgrading a userspace tool is much
> much easier than upgrading a kernel.
> 
> Also, the actual "driver" for the device (i.e. the modem part) doesn't need
> an upgrade to the kernel component for these types of devices.
> 
> Finally, these sorts of databases don't belong in the kernel as much as
> possible.
> 
> The usb-storage driver will not accept patches for device which can be
> supported via userspace-only tools.

And just to confirm, I support Matthew's position.

thanks,

greg k-h
