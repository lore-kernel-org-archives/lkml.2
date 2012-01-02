Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2ABOyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 09:54:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39988 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab2ABOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 09:54:43 -0500
Date: Mon, 2 Jan 2012 14:54:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCHv3 1/3] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20120102145439.GR4300@opensource.wolfsonmicro.com>
References: <1325508798-25439-1-git-send-email-jamie@jamieiles.com>
 <1325508798-25439-2-git-send-email-jamie@jamieiles.com>
 <20120102132500.GB18443@sirena.org.uk>
 <20120102135145.GA25420@page>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102135145.GA25420@page>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 01:51:45PM +0000, Jamie Iles wrote:
> On Mon, Jan 02, 2012 at 01:25:00PM +0000, Mark Brown wrote:

> > > v2:	- use Rob Herring's irqdomain in generic irq chip patches
> > > 	- use reg property to indicate bank index
> > > 	- support irqs on both edges based on LinusW's u300 driver

> > Put stuff like this after the ---, it shouldn't end up in git history.

> Grant (and others I believe) have asked to have it above the separator 
> in the past to ensure that it does end up in the history.  This helps 
> make it clear what version got applied and it's a lot easier for patch 
> authors to manage rather than keeping it out of band.

You end up with content-free junk in the changelogs like "v2: rewrite
with new API" (I've actually had that...) which just isn't instructive
to anyone reading the logs later; if there were some way of going from
the changelog back to the actual code that'd be one thing but then
there's a reason why we don't carry the out of tree revision control
history.

Note that patch changelogs are one of the specific examples given in
SubmittingPatches for inclusion after the ---.

Personally I'm not convinced carrying any out of tree change history
except the delta from the last version submitted is useful as the actual
code changes aren't readily available and the fact that there were
earlier versions with bugs or whatever isn't terribly instructive.  The
delta from the last version is useful for helping to focus review but
the rest of it gets very noisy.  If the history is really useful
probably merging an actual branch with is much more helpful, if it's
getting troublesome to manage it and that's not suitable then I'd just
drop it.

> Something like this?

Yes, exactly thanks.
