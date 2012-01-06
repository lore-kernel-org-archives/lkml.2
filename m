Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab2AFXuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:50:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47428 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759152Ab2AFXuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:50:13 -0500
Date: Fri, 6 Jan 2012 15:49:27 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, Frank Mandarino <fmandarino@endrelia.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the driver
 model
Message-ID: <20120106234923.GI2893@opensource.wolfsonmicro.com>
References: <20120106194052.GA7781@kroah.com>
 <20120106201458.GF2893@opensource.wolfsonmicro.com>
 <20120106205036.GB13857@n2100.arm.linux.org.uk>
 <20120106234135.GH2893@opensource.wolfsonmicro.com>
 <20120106234445.GC13857@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106234445.GC13857@n2100.arm.linux.org.uk>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 11:44:45PM +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 06, 2012 at 03:41:39PM -0800, Mark Brown wrote:
> > This only helps this specific device model bit of things, if anything is
> > still actually holding a reference to the device and tries to use it
> > after we tore away the resource underneath it we'll still explode (never
> > mind the fact that we're backing this stuff up with some global pointers
> > to other devices which may or may not actually be there...).

> Err what?  Explain showing the code where you think this is the case
> with the patch I proposed please.

These aren't new problems being introduced, they're preexisting problems
which aren't fixed by this (hence why I say it "only helps with this
specific device model side of things") but can come up in pretty much
the same circumstances.
