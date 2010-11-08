Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0KHMdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:33:54 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:21549 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0KHMdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:33:53 -0500
Date: Mon, 8 Nov 2010 13:33:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for    
 pr_fmt(fmt)
Message-ID: <20101108133342.7217866c@endymion.delvare>
In-Reply-To: <1288390250.28828.228.camel@Joe-Laptop>
References: <1287713982.16920.39.camel@Joe-Laptop>
	<20101026110335.3a4c7679@endymion.delvare>
	<1288201301.4145.122.camel@Joe-Laptop>
	<20101028093529.503c3a28@endymion.delvare>
	<1288252476.1836.9.camel@Joe-Laptop>
	<20101028104354.6aaca07c@endymion.delvare>
	<1288390250.28828.228.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Sorry for the late answer.

On Fri, 29 Oct 2010 15:10:50 -0700, Joe Perches wrote:
> On Thu, 2010-10-28 at 10:43 +0200, Jean Delvare wrote:
> > Besides, linux-next is meant for integration testing. We already know
> > that the change will integrate fine, in that it won't cause a build
> > failure or runtime crash. We also know that, without the tree-wide
> > cleanup of many driver, the change will cause duplicate prefixes in
> > many messages.
> > 
> > There's little point in testing something we know will not be good
> > enough. Better prepare all the driver patches, and test the whole thing
> > when it's ready. I know it will be a very large and intrusive patchset,
> > but this can certainly be done with Andrew's support.
> 
> I think you underestimate the time, effort and acceptance
> levels by the various arches and maintainers required.
> 
> Also, it's not just drivers, it's arch, lib, and kernel.
> (...)

I've had time to think about it all some more, and I have to admit that
my counter-proposal doesn't really fly. Changing everything at once
throughout the whole kernel tree is simply too difficult.

So I hate to admit it, but your initial proposal was certainly better,
because it can be done one subsystem at a time. So I think we should
forget about my objections and go on with your first patchset.

That being said, to avoid messing up the kernel tree completely, I
think we need a clearly defined plan before we start. This plan should
include:
* A clear statement of goal.
* An explanation of the steps we have to go through to reach it.
* An rough schedule of when it will happen (in either time or kernel
  versions) with a deadline after which changing the default definition
  of pr_fmt() will be considered OK.

And the plan should be made known to all subsystem maintainers, with
publicly visible progress tracking. Otherwise I fear it will take
forever to reach your goal.

Thanks,
-- 
Jean Delvare
