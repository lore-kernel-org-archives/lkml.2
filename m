Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1EKB6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 21:58:49 -0400
Received: from kroah.org ([198.145.64.141]:35707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab1EKB6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 21:58:47 -0400
Date: Tue, 10 May 2011 18:56:50 -0700
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v6] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20110511015650.GA6840@kroah.com>
References: <1305040232-750-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110510200801.GA8125@kroah.com>
 <BANLkTimimx-pW9mOtb_9yM5XcQ5nOeGYug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimimx-pW9mOtb_9yM5XcQ5nOeGYug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 02:07:33AM +0200, Linus Walleij wrote:
> 2011/5/10 Greg KH <greg@kroah.com>:
> 
> > On Tue, May 10, 2011 at 05:10:32PM +0200, Par-Gunnar Hjalmdahl wrote:
> >> This patch adds support for the ST-Ericsson CG2900
> >> Connectivity Combo controller (Bluetooth, FM, GPS).
> >>
> >> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > {sigh}
> >
> > This breaks the build again, the error messages are below :(
> 
> I suspect the problem is that Per-Gunnar does not know how to reproduce
> your build errors. Are you building for some x86 combination, allyes, etc
> for example? This is likely currently only tested and applicable for ux500
> so a simple  "depends on ARCH_U8500" under config CG2900 may solve
> stuff.

All I did was merely enable the driver to be built on my desktop,
something that any developer should have done, right?

And why can't the code be built for any architecture, what is forcing it
for only one platform?  That's not the way drivers should be written,
right?

So please fix the real problem, don't just confine it to one
architecture, what is to keep this from showing up on another chip soon?

thanks,

greg k-h
