Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1BQGIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 01:08:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51329 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752124Ab1BQGIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 01:08:04 -0500
Date: Thu, 17 Feb 2011 06:08:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110217060800.GA9645@opensource.wolfsonmicro.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171531.03924.manningc2@actrix.gen.nz> <20110217034914.GB5194@opensource.wolfsonmicro.com> <201102171722.15683.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102171722.15683.manningc2@actrix.gen.nz>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 05:22:15PM +1300, Charles Manning wrote:
> On Thursday 17 February 2011 16:49:14 Mark Brown wrote:

> > You're missing the use case here - I'm talking about the situation where
> > you completely ignore the vendor BSP and go direct to mainline without
> > reference to the vendor provided stuff.  The user may not even have the
> > vendor provided BSP to look at.

> I don't understand what problem you are trying to illustrate.

> First off, kernel BSPs should always be available in accordance with the GPL.

Sure, but the effort involved in obtaining them (especially for older
boards) often greatly exceeds the value of looking at them - often it's
much easier to go direct to mainline.

> Secondly the defaults work for just about every case. So long as the mtd has 
> been set up then dropping in yaffs using defaults is generally pretty 
> straight forward and there is no tuning required,

> Some tuning is required if the mtd does not pass through all the info that is 
> required. In the fullness of time I would expect that this info would be 
> provided by mtd.

Your descriptions made it sound like tthis was higher level information
that was being provided.  If it's just fixups to the flash description
then I would expect that the flash driver would handle it as you suggest.

> My point was that the "platform data" -- well just about all of it -- is 
> exposed via the mtd interface. That tells you the number of blocks, block 
> size, bytes per block etc. Enough to figure out almost all the runtime stuff.

Right, which is why I'm assuming that this build time configuration
stuff is things that can't be read directly from the hardware and needs
to be passed in via some other mechanism.  If it's stuff that can be
read from the MTD subsystem then clearly it should be read from the MTD
subsystem.

> I think I can dump all the config stuff and just set it to the most useful 
> defaults. Many of the settings are really only there for debug etc.

That sounds like a good plan.
