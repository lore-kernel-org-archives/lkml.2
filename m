Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab2AEFqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 00:46:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50090 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab2AEFqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 00:46:31 -0500
Date: Thu, 5 Jan 2012 05:46:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com
Subject: Re: [PATCHv3 1/3] gpio: add a driver for the Synopsys DesignWare
	APB GPIO block
Message-ID: <20120105054630.GB11867@opensource.wolfsonmicro.com>
References: <1325508798-25439-1-git-send-email-jamie@jamieiles.com> <1325508798-25439-2-git-send-email-jamie@jamieiles.com> <20120102132500.GB18443@sirena.org.uk> <20120104182133.GS15503@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104182133.GS15503@ponder.secretlab.ca>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 11:21:33AM -0700, Grant Likely wrote:
> On Mon, Jan 02, 2012 at 01:25:00PM +0000, Mark Brown wrote:

> > > v2:	- use Rob Herring's irqdomain in generic irq chip patches
> > > 	- use reg property to indicate bank index
> > > 	- support irqs on both edges based on LinusW's u300 driver

> > Put stuff like this after the ---, it shouldn't end up in git history.

> I disagree.  Keeping the revision history in the git commit is
> actually quite useful when trying to figure out which version of a
> patch actually got applied.  I'm asking patch authors to keep it above
> the ---

I wouldn't be completely opposed to keeping *a* version in, the thing
that gets me is the entire changelog - it gets really noisy quite
quickly and the history for the patch ends up dominating the changelog.
The older entries normally have vanishingly little utility without the
changes (and where they do should normally be written into the actual
description of the change) and all you need to know which version got
applied is information on the most recent revision.

But TBH you could also get the version by just putting it in the subject
outside of [ ] so it doesn't get stripped.
