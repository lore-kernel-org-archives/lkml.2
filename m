Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935439Ab0KQT4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:56:46 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46671 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935187Ab0KQT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:56:45 -0500
Date: Wed, 17 Nov 2010 20:58:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Eric Cooper <ecc@cmu.edu>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101117195843.GA31357@elf.ucw.cz>
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
 <20101117105925.GC1574@ucw.cz>
 <20101117160919.GC10992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117160919.GC10992@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Add a netdev LED trigger for all Blinkenlights lovers...
> > > Originally taken from https://dev.openwrt.org/ticket/2776
> > > Slightly updated for 2.6.24 by Mickey Lauer <mickey@openmoko.org>
> > > and for 2.6.36 by Eric Cooper <ecc@cmu.edu>
> > 
> > Nice!
> > 
> > > +/*
> > > + * Configurable sysfs attributes:
> > > + *
> > > + * device_name - network device name to monitor
> > > + *
> > > + * interval - duration of LED blink, in milliseconds
> > 
> > This needs to go to Doc/ somewhere.
> 
> Documentation/ABI is the correct place for it.

I was hoping you'd comment on the ABI itself, too. It uses 

echo "foo bar baz" > file

to enable/disable specific events to be "displayed". More traditional
interface would be 

echo disable > file_foo

...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
