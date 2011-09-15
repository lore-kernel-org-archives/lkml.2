Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502Ab1IOTQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:16:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54890 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934446Ab1IOTQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:16:51 -0400
Date: Thu, 15 Sep 2011 20:16:30 +0100
From: Russell King <rmk+alsa@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build
	failure
Message-ID: <20110915191630.GA21615@flint.arm.linux.org.uk>
References: <1315991893.17271.2.camel@phoenix> <20110914191917.GA30518@flint.arm.linux.org.uk> <20110914232808.GC2953@opensource.wolfsonmicro.com> <20110914233838.GB22946@flint.arm.linux.org.uk> <20110915094640.GA7988@opensource.wolfsonmicro.com> <20110915110056.GA32615@flint.arm.linux.org.uk> <20110915133122.GG7988@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915133122.GG7988@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 02:31:22PM +0100, Mark Brown wrote:
> On Thu, Sep 15, 2011 at 12:00:56PM +0100, Russell King wrote:
> > If it's not dead then it needs sorting out.  Either way there's two
> > valid states:  1. fully merged, or 2. none of it is merged.
> > There's no real half-way house state - certainly not one which should
> > persist for three years.  (It would be reasonable for maybe a couple
> > of kernel releases but more than that is becoming very much a joke.)
> 
> I'm not really aware of what's going on with the arch/arm code but from
> an ASoC point of view it's one of the platforms people seem to usefully
> care about; there's more traffic than for most machines.  Obviously the
> problems with s3c24xx aren't going to have been helpful either.

It sounds like you're in the perfect place to send them a warning
that something needs to happen on this, one way or the other.

Whether anyone volunteers should be used as a factor in deciding
how to deal with the small bits of GTA01 support in mainline.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
