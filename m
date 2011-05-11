Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1EKQTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:19:13 -0400
Received: from kroah.org ([198.145.64.141]:35355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab1EKQTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:02 -0400
Date: Wed, 11 May 2011 06:48:59 -0700
From: Greg KH <greg@kroah.com>
To: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v6] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20110511134859.GB12717@kroah.com>
References: <1305040232-750-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110510200801.GA8125@kroah.com>
 <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A1A289@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A1A289@EXDCVYMBSTM005.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:34:47AM +0200, Par-Gunnar HJALMDAHL wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: den 10 maj 2011 22:08
> > 
> > {sigh}
> > 
> > This breaks the build again, the error messages are below :(
> > 
> > I'm about to give up here, so the next time you send this patch in, I
> > want some kind of proof that the code will at least build properly.
> > 
> > How you provide this is up to you.
> > 
> > Oh, and if the next one breaks stuff again, you will owe me a lot of
> > beer, although I think you owe me already...
> > 
> > thanks,
> > 
> > greg k-h
> > 
> >   CC [M]  drivers/staging/cg2900/mfd/cg2900_chip.o
> > drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: unknown field
> > ‘platform_data’ specified in initializer
> > drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: warning:
> > initialization makes integer from pointer without a cast
> > drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: initializer
> > element is not computable at load time
> > drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: (near
> > initialization for ‘cg2900_devs[0].id’)
> 
> Hi Greg,
> 
> What linux-next tag did you base the patch on?

My staging git tree.  I can't apply to linux-next, only my tree,
linux-next then picks it up.

> I used next-20110510 and in that tag the file include/Linux/mfd/core.h
> The struct mfd_cell has a parameter called platform_data, while in your
> build it seems it doesn't.
> This was changed very recently in the core.h file (on April 6).
> So for core.h the last commit ID I have in the tag I built upon is
> 558aa9c0d620b91a896d5e39ce8a570bed65589b.

So do I need that patch on the staging-next tree also?

Or is it an issue of building this on x86-64...

thanks,

greg k-h
