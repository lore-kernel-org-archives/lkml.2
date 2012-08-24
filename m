Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab2HXUgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:36:36 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:29672 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933343Ab2HXUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:36:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18wzMRV/pNXG8e6hCUJp8II
Date: Fri, 24 Aug 2012 13:36:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more
 mach-*/*.h includes
Message-ID: <20120824203622.GB1303@atomide.com>
References: <201208221253.07278.arnd@arndb.de>
 <20120822214323.GA12255@n2100.arm.linux.org.uk>
 <201208231135.11688.arnd@arndb.de>
 <201208231726.11293.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208231726.11293.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120823 10:27]:
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
> 
> 	Arnd
> 
> The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:
> 
>   Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git 

I'd like to run some checks on this, but branch name missing here for
pulling a branch in for testing..
 
> for you to fetch changes up to 25296e032db173e8376123c2801cd233c9dc9b78:

..and -ENOSUCHCOMMIT after fetching in arm-soc tree.

Regards,

Tony
