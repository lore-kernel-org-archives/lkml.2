Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1HHSGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:06:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35733 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1HHSGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:06:01 -0400
Date: Mon, 8 Aug 2011 19:05:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] arm/tegra: Delete irq_to_gpio
Message-ID: <20110808180540.GC19367@n2100.arm.linux.org.uk>
References: <1312582534-10871-1-git-send-email-swarren@nvidia.com> <1312582534-10871-2-git-send-email-swarren@nvidia.com> <20110806174519.GB31966@ponder.secretlab.ca> <74CDBE0F657A3D45AFBB94109FB122FF049F172168@HQMAIL01.nvidia.com> <CAOesGMi2CXyAoy56-SdaD5YFzXW6W4wP6mnH+bVvRR3i_Mhk2A@mail.gmail.com> <CACxGe6ubndfYNxgRfrLtCZ8cP0FddwTpG_FBZKXVZb0OHJVt6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6ubndfYNxgRfrLtCZ8cP0FddwTpG_FBZKXVZb0OHJVt6w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 11:50:47AM -0600, Grant Likely wrote:
> On Aug 8, 2011 8:26 AM, "Stephen Warren" <swarren@nvidia.com> wrote:
> >
> > Grant Likely wrote at Saturday, August 06, 2011 11:45 AM:
> > > On Fri, Aug 05, 2011 at 04:15:34PM -0600, Stephen Warren wrote:
> > > > irq_to_gpio is deprecated and in the process of being removed. Make that
> > > > happen now for ARM Tegra.
> > > >
> > > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > >
> > > Applied both.  Thanks.
> >
> > Didn't you want an Ack by a Tegra maintainer first?
> 
> It looks like a pretty low risk change.  I didn't see much risk in
> picking it up and getting it off my plate.  I can always pull things
> back out of my tree if someone complains.  I'll add Olof's ack before
> it gets into linux-next.
> 
> >
> > I assume they were both applied to gpio-next (although a fresh fetch  of that
> > doesn't show the commits)
> 
> I can't push it out until after 3.1-rc1 is released because it is
> targeted at 3.2 now.

It'd probably make sense for it to be merged into my tree along with
the rest of my gpio changes, otherwise we're going to head for merge
conflicts.  I'll be publishing those gpio.h changes in the next few
days.
