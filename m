Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935445Ab0KQUBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:01:17 -0500
Received: from kroah.org ([198.145.64.141]:37574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935187Ab0KQUBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:01:16 -0500
Date: Wed, 17 Nov 2010 12:01:00 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Cooper <ecc@cmu.edu>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101117200100.GA30815@kroah.com>
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
 <20101117105925.GC1574@ucw.cz>
 <20101117160919.GC10992@kroah.com>
 <20101117195843.GA31357@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117195843.GA31357@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 08:58:43PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > Add a netdev LED trigger for all Blinkenlights lovers...
> > > > Originally taken from https://dev.openwrt.org/ticket/2776
> > > > Slightly updated for 2.6.24 by Mickey Lauer <mickey@openmoko.org>
> > > > and for 2.6.36 by Eric Cooper <ecc@cmu.edu>
> > > 
> > > Nice!
> > > 
> > > > +/*
> > > > + * Configurable sysfs attributes:
> > > > + *
> > > > + * device_name - network device name to monitor
> > > > + *
> > > > + * interval - duration of LED blink, in milliseconds
> > > 
> > > This needs to go to Doc/ somewhere.
> > 
> > Documentation/ABI is the correct place for it.
> 
> I was hoping you'd comment on the ABI itself, too. It uses 
> 
> echo "foo bar baz" > file
> 
> to enable/disable specific events to be "displayed". More traditional
> interface would be 
> 
> echo disable > file_foo

Sorry, yes, I missed that.  It would be obvious that the api was
incorrect once it was documented in the correct format :)

thanks,

greg k-h
