Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab2HXUrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:47:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45186 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab2HXUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:47:48 -0400
Date: Fri, 24 Aug 2012 21:47:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more
	mach-*/*.h includes
Message-ID: <20120824204737.GE18957@n2100.arm.linux.org.uk>
References: <201208221253.07278.arnd@arndb.de> <20120822214323.GA12255@n2100.arm.linux.org.uk> <201208231135.11688.arnd@arndb.de> <201208231726.11293.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208231726.11293.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:26:10PM +0000, Arnd Bergmann wrote:
> On Thursday 23 August 2012, Arnd Bergmann wrote:
> > On Wednesday 22 August 2012, Russell King - ARM Linux wrote:
> > > In any case, what we should be doing here as well is moving the headers
> > > included by drivers for platform data out of the arch/arm/mach/ subtrees
> > > and into include/linux/platform_data.  That will substantially reduce the
> > > amount of mach/ headers to deal with.
> > 
> > I've just looked at the {mach,plat}/*.h files that get included in ARM
> > specific drivers. Out of the 342 header files that get used in this way,
> > I found 93 that are practically just platform data, and a few that
> > are platform_data mixed with something else.
> > 
> > How about I move all the pure platform data definition files now and
> > rebase the other patches on top of that. Here is a list of suggested
> > file names in include/linux/platform_data/:
> 
> I've just scripted this and am running my build testsuite over it now.
> 
> Please let me know what you think about it.

This certainly looks like a step in the right direction, thanks for doing
this.
