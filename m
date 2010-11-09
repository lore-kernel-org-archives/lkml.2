Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KIWLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:11:45 -0500
Received: from kroah.org ([198.145.64.141]:48038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0KIWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:11:43 -0500
Date: Tue, 9 Nov 2010 14:10:35 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
Message-ID: <20101109221035.GB19847@kroah.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
 <AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
 <201011091729.17679.arnd@arndb.de>
 <20101109165509.GA9698@kroah.com>
 <AANLkTinFW431t9XFqHc=wZAws9gjT0ikrc03J83kH7iF@mail.gmail.com>
 <20101109172511.GA10958@kroah.com>
 <AANLkTi=CKERMcSLXwQa7G55P69DO--UPN9HgOScHP_yO@mail.gmail.com>
 <20101109175828.GA27627@kroah.com>
 <AANLkTin0Lszi6MVo8GBWmpvMQRL3V+VGbtGdaMkBe5XO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin0Lszi6MVo8GBWmpvMQRL3V+VGbtGdaMkBe5XO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:53:29PM +0200, Felipe Contreras wrote:
> On Tue, Nov 9, 2010 at 7:58 PM, Greg KH <greg@kroah.com> wrote:
> > If it is easy to revert and push later, then the "revert just this
> > piece" should be done now.
> >
> > Seriously, I'm getting very confused here, and am very annoyed by the
> > whole thing.
> 
> With good reason.
> 
> > Here's what I don't like:
> >  - the original driver didn't even seem to work properly
> 
> It _was_ working properly, when it was a separate branch, but the
> merge to staging wasn't done correctly, so it has never worked there.

Well, blame the people who sent it to me then :)

> >  - people sent me patches they never tested and broke things even worse
> 
> Part of the blame goes to TI. Even if you have the hardware, it's not
> straightforward to test this. I have struggled to improve the
> situation on user-space with the gst-dsp and dsp-tools projects, which
> btw have not received support from TI, but apparently they were not
> used to test this (neither was the "official" solution from TI which
> is much harder to set up).
> 
> >  - some people have no respect for the omap maintainers and what they
> >    think about things, or even basic knowledge of the kernel
> >    development cycle.
> 
> I don't think this is the case. The opinion of the OMAP maintainers is
> valuable in order to cleanup the mess that is this driver. But _first_
> it has to work. Most people are not developers, they just want to use
> this driver.
> 
> >  - I do not have this hardware so I can't test anything.
> >
> > So, from now on, I'm not taking ANYONES patches for this driver unless
> > it gets an ack from the driver maintainer, Omar Luna.
> >
> > Actually, no, I'm not going to take any patch unless it _comes from_
> > Omar.  Omar, please work to queue up patches and test them, and then
> > send them to me for merging.
> >
> > Any questions?
> 
> You mean after this pull, or should Omar re-send this pull request?

I'm not pulling _anything_ at the moment for this driver.

I want to see patches, not a pull request please, as these need to be
reviewed very closely.

thanks,

greg k-h
