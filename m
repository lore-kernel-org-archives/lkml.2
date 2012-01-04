Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2ADTGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:06:17 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51347 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2ADTGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:06:12 -0500
Date: Wed, 4 Jan 2012 11:21:33 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com
Subject: Re: [PATCHv3 1/3] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20120104182133.GS15503@ponder.secretlab.ca>
References: <1325508798-25439-1-git-send-email-jamie@jamieiles.com>
 <1325508798-25439-2-git-send-email-jamie@jamieiles.com>
 <20120102132500.GB18443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102132500.GB18443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 01:25:00PM +0000, Mark Brown wrote:
> On Mon, Jan 02, 2012 at 12:53:16PM +0000, Jamie Iles wrote:
> > The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> > and can be configured to provide multiple banks of GPIO pins.
> > 
> > v3:	- depend on rather than select IRQ_DOMAIN
> > 	- split IRQ support into a separate patch
> > v2:	- use Rob Herring's irqdomain in generic irq chip patches
> > 	- use reg property to indicate bank index
> > 	- support irqs on both edges based on LinusW's u300 driver
> 
> Put stuff like this after the ---, it shouldn't end up in git history.

I disagree.  Keeping the revision history in the git commit is
actually quite useful when trying to figure out which version of a
patch actually got applied.  I'm asking patch authors to keep it above
the ---

g.

