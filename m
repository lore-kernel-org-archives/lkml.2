Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0KJJx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:53:58 -0500
Received: from ist.d-labs.de ([213.239.218.44]:53961 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0KJJx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:53:57 -0500
Date: Wed, 10 Nov 2010 10:53:33 +0100
From: Florian Mickler <florian@mickler.org>
To: "Ted Ts'o" <tytso@mit.edu>
Newsgroups: gmane.linux.kernel
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101110105333.6ef067f2@schatten.dmk.lab>
In-Reply-To: <20101110003524.GL3099@thunk.org>
References: <20101109223225.5e261346@lxorguk.ukuu.org.uk>
	<20101110003524.GL3099@thunk.org>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 19:35:24 -0500
Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Nov 09, 2010 at 10:32:25PM +0000, Alan Cox wrote:
> > > Ah, but if you make changes to the android userspace that aren't
> > > accepted upstream by the core android development team, you'll be
> > > forking the android userspace.  And given that they are continuing to
> > 
> > Oh so forking the kernel is fine but forking userspace is silly. Quaint
> OTOH, if the original poster thinks that he can develop changes to the
> Android userspace that allow the use of an upstream kernel, and has
> just as good battery lifetime, and with a system which is just as
> debuggable and easy to maintain as the current android userspace, then
> by all means, I would love for him to try to prove that he can.  And I
> will certainly be happy to introduce him to the Android developers who
> measure power usage in mobile devices using microwatt meters to see if
> he really can do as good of a job using a stock kernel.
> 
> So Elvis, if you think you can, please consider this a challenge!  :-)
> 
> Or if he just wants to get the drivers into mainline so that other
> non-Android devices can use those particular chipsets, that's good
> too.  I just hope that he can do appropriate testing so that he can be
> a good maintainer for the drivers, which means testing them.  Pushing
> code that may or may not work isn't necessarily an improvement!
> 
>        	  	    	       	     	      - Ted

I don't think _maintaining_ a fork is currently necessary or worthwile.
But what could be useful as a proove of concept, would be to try to
express the original wake-lock api (the one that is currently in use on
android) in terms of the mechanisms currently in mainline.

That way, Rafael would probably get useful feedback on
pm_wakeup_event() (and friends) implementation.

Regards,
Flo

