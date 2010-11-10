Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0KJAfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:35:38 -0500
Received: from THUNK.ORG ([69.25.196.29]:39800 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab0KJAfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:35:32 -0500
Date: Tue, 9 Nov 2010 19:35:24 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101110003524.GL3099@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Elvis Dowson <elvis.dowson@mac.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109223225.5e261346@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:32:25PM +0000, Alan Cox wrote:
> > Ah, but if you make changes to the android userspace that aren't
> > accepted upstream by the core android development team, you'll be
> > forking the android userspace.  And given that they are continuing to
> 
> Oh so forking the kernel is fine but forking userspace is silly. Quaint

I didn't say that it was silly; that was your words.  What I said is
that it's not clear any handset manufacturers would pay attention to
the forked android userspace (which was his assumption/hope).  Whether
or not it is "silly" depends on what goals are for the original
poster.  If he is trying to effect change in terms of how the handset
manufactures do their driver development, then it might not meet his
goals.  If he wants to do it for the technical challenge, then of
course he should be encouraged to do whatever give it a go....

I suspect that sometimes we of the LKML community are in danger of
believing our own propaganda, and assume that getting code into
mainline, and developing in mainline is always better than any
alternative, and is higher priority than any other consideration.  If
a product had 33% less battery lifetime, but was developed in
mainline, would you buy that over a standard product?  OK, maybe a
LKML denizen might.  But would most customers?

OTOH, if the original poster thinks that he can develop changes to the
Android userspace that allow the use of an upstream kernel, and has
just as good battery lifetime, and with a system which is just as
debuggable and easy to maintain as the current android userspace, then
by all means, I would love for him to try to prove that he can.  And I
will certainly be happy to introduce him to the Android developers who
measure power usage in mobile devices using microwatt meters to see if
he really can do as good of a job using a stock kernel.

So Elvis, if you think you can, please consider this a challenge!  :-)

Or if he just wants to get the drivers into mainline so that other
non-Android devices can use those particular chipsets, that's good
too.  I just hope that he can do appropriate testing so that he can be
a good maintainer for the drivers, which means testing them.  Pushing
code that may or may not work isn't necessarily an improvement!

       	  	    	       	     	      - Ted
