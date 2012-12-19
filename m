Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2LSKnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:43:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56830 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2LSKmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:42:54 -0500
Message-ID: <1355913722.5273.18.camel@cumari.coelho.fi>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
From: Luciano Coelho <coelho@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Date: Wed, 19 Dec 2012 12:42:02 +0200
In-Reply-To: <20121219102835.GP4985@opensource.wolfsonmicro.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
	 <20121218095450.GB27751@arwen.pp.htv.fi>
	 <20121219094552.GN4985@opensource.wolfsonmicro.com>
	 <1355911317.5273.10.camel@cumari.coelho.fi>
	 <20121219102835.GP4985@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 10:28 +0000, Mark Brown wrote:
> On Wed, Dec 19, 2012 at 12:01:57PM +0200, Luciano Coelho wrote:
> 
> > I think one of the reasons not many people use the mainline with TWL is
> > exactly because something seems to break on every new kernel release.
> > I'm one of those who care and report things when I see them.
> 
> Well, it's a recursive thing - nobody works on mainline, nobody reviews
> mainline code and therefore you shouldn't be surprised if there's
> issues.

Sure, it's a vicious circle.  In any case, I still endure using it and
going against the flow. ;)


> > I think saying that it is not important because only one person reported
> > it is not a good excuse.  I would at least have liked seeing an answer
> > saying, "this can't be fixed because of this and that" or "can you try
> > to fix it by doing this or that".
> 
> That's not what I'm saying.  What I'm saying is that it's clearly not
> the case that OMAP is completely broken here or anything, it appears to
> be one particular system which it appears vanishingly few people cared
> about in mainline even before all the stuff with TI recently.

You're right.  I also had problems with MMC in a Pandaboard too, but I
didn't even bother investigating it (yet) because I can use my other
setup.


> Looking at your report the reason I didn't reply myself is most likely
> to be a combination of my expectation that someone from TI would look at
> OMAP problems (at the time there were hundreds of people working on
> OMAP) and the lack of detail in your mail - the bisection report was a
> bit unclear as you said that you'd reverted the patch "plus a couple of
> associated patches" without saying what exactly you'd backed out and
> there was no analysis of the problem to engage with.

Right, my report was a bit vague indeed.  What I meant by "plus a couple
of associated patches" was the things that would break compilation if I
reverted only the patch in question.  Most likely I ended up reverting
your whole patchset.

I didn't provide further analysis because I had already spent too much
time trying to figure out how to get my stuff to work.  Reverting the
patches locally and hoping someone would respond to my report was good
enough for me at the time.

I also agree that someone from OMAP should have picked it up, but my
report went out exactly when the bomb was exploding inside TI.  So that
probably explains it.

--
Cheers,
Luca.

