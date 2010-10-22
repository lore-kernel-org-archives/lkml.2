Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0JVXD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:03:27 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:39777 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0JVXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:03:26 -0400
Date: Fri, 22 Oct 2010 19:03:17 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [-next] staging/vme: various fixes + new driver model for VME
Message-ID: <20101022230317.GM10869@flamenco.cs.columbia.edu>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
 <4CC158B3.5010908@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC158B3.5010908@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 10:26:11 +0100, Martyn Welch wrote:
> On 22/10/10 07:36, Emilio G. Cota wrote:
> 
> Hi Emilio,
> 
> Thank you for the fixes. After a quick glance, there seem to be a number
> of valid fixes here, but I'm very concerned by the patches that change
> the driver model. We discussed this approach in August last year, I am
> still yet to be convinced by the approach you wish to take.

Yes I remember we discussed it privately. I didn't provide a solution
at that point, I just told you that I believed the model could
be improved--and this is my attempt.

> > 
> > - Make DMA work on the tsi148 (it's the only bridge I've got).
> >   This will probably involve changing or extending the
> >   current API.
> 
> The DMA is already working on the tsi148. In what way do you feel that
> the current API needs changing or extending for DMA?

Sorry I may be confused here. That's the impression I got after reading
the DMA code a few months ago.

Anyway forget about this for the time being.

> > - Test the whole thing with real hardware and a real VME driver
> >   (currently out of tree as well, see [2]), which I'll try
> >   to get merged, too--currently we just have vme_user.c which
> >   really isn't a kosher driver.
> > 
> 
> The current API has been tested with real hardware, for both supported
> vme bridges, on multiple cards, by multiple people. If the changes to
> the API are to be applied, they would need to be throughly tested before
> they are applied. As I've said above - I am still not convinced by the
> change in approach.

Well what we have merged is just vme_user, which is an unusual driver
that is not even finished yet. I can't speak of what's not merged.

Don't get me wrong, I didn't mean to say that the current code has
never been tested.

What I wanted to say is that I could eventually merge a driver, and
that could validate the whole thing. However I wouldn't like to
port everything, test it, and then get a NAK because of the changed
driver model. So that's why I'm sending this first--I don't mind
if it's not yet merged, but at least I'd like to know if I'm on
the right track.

Thanks

		Emilio
