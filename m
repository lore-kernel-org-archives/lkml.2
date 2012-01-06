Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab2AFXgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:36:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759321Ab2AFXfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:35:40 -0500
Date: Fri, 6 Jan 2012 15:17:27 -0800
From: Greg KH <gregkh@suse.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: NeilBrown <neilb@suse.de>, Brian Swetland <swetland@google.com>,
        "david@lang.hm" <david@lang.hm>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@osdl.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: android logger feedback request
Message-ID: <20120106231727.GA24043@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222122026.3a0fae36@notabene.brown>
 <alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
 <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
 <20111222180517.20bce47d@notabene.brown>
 <4F075FFB.4090703@am.sony.com>
 <20120106212054.GA19509@suse.de>
 <4F0778B0.3050104@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0778B0.3050104@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 02:41:52PM -0800, Tim Bird wrote:
> > But for almost everything else (and
> > really, there isn't all that much android-only code we are talking about
> > here:
> > $ wc drivers/staging/android/* drivers/staging/android/switch/* -l | tail -n 1
> >    8429 total
> > 
> > And the switch code is already being worked on to be generalized by
> > others, so that means we only have:
> > $ wc drivers/staging/android/*  -l | tail -n 1
> >    8015 total
> > to worry about here.
> 
> Well, I'm not sure you've gotten it all (my count is closer to 20k,
> some of it sprinkled in a few weird places), but I agree completely
> that it's not a lot of code, which is encouraging.  Did you put
> anything in besides what's in staging?

Yes, it should all be under drivers/staging/android in linux-next, soon
to go to Linus.

What do you think I have missed?  I only know of two missing bits:
	- android USB gadget drivers/stuff
	- wakelocks

The first is being addressed by the Google developers, see the post to
the linux-usb mailing list the end of last month with the code, and all
of the review comments on it.

The second is being worked on by someone else, as I'm sure you are
already aware.

Other than that, I don't see anything in the common.git android tree
that I am missing, other than some odd driver updates which should all
be upstream already from what I can tell.

So how are our line counts so far off?

thanks,

greg k-h
