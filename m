Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1CMBH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 20:07:29 -0500
Received: from kroah.org ([198.145.64.141]:47466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab1CMBG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 20:06:56 -0500
Date: Sat, 12 Mar 2011 17:06:33 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        l-m <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        l-o <linux-omap@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tuomas Kulve <tuomas@kulve.fi>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
Message-ID: <20110313010633.GD20396@kroah.com>
References: <1299889746-16502-1-git-send-email-omar.ramirez@ti.com>
 <20110312173626.GC24981@kroah.com>
 <AANLkTinp0e4EiEH=XV9gCSJzoh-VAY-6qqs91x0s80ro@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinp0e4EiEH=XV9gCSJzoh-VAY-6qqs91x0s80ro@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 01:42:35AM +0200, Felipe Contreras wrote:
> On Sat, Mar 12, 2011 at 7:36 PM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Mar 11, 2011 at 06:29:06PM -0600, Omar Ramirez Luna wrote:
> >> Please consider to apply this patch in the staging tree, as the
> >> description says it fixes a crash in tidspbridge driver, this bug
> >> was already present but it seems to have surfaced by recent tests
> >> made by Felipe and Tuomas.
> >>
> >> It is an urgent fix for 2.6.38.
> >
> > Heh, it's funny to see such a "urgent" fix take so long to get to me :)
> 
> Well, depending on your hardware and use-case this might or might not
> be urgent. At least for some people the driver is unusable without
> this.

Urgency is all relative :)

> > Is it also applicable for .37?
> 
> Yes.

In the future, always say this so I don't have to ask please.

> > How about I send it to Linus for .39 and then add it to the .38-stable
> > tree when it comes out?
> 
> That was the plan for .38/.37-stable. I'd say that's fine, but it
> would be even better to avoid people getting bit by this on plain .38.

What is one more week, when you all waited months to get this to me?  In
other words, why should I suddenly now rush when no one else did?

I'll queue this up for .39 and mark it for stable inclusion.

thanks,

greg k-h
