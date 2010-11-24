Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0KXSSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:18:49 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:21652 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0KXSSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:18:44 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFrm7EyrRN+K/2dsb2JhbACjBHGjUJtGhUcEhFuLGA
X-IronPort-AV: E=Sophos;i="4.59,249,1288569600"; 
   d="scan'208";a="384426229"
Date: Wed, 24 Nov 2010 10:18:26 -0800
From: David VomLehn <dvomlehn@cisco.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org
Subject: Re: RFC: Mega rename of device tree routines from of_*() to dt_*()
Message-ID: <20101124181825.GA17112@dvomlehn-lnx2.corp.sa.net>
References: <1290607413.12457.44.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290607413.12457.44.camel@concordia>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 01:03:33AM +1100, Michael Ellerman wrote:
> Hi all,
> 
> There were some murmurings on IRC last week about renaming the of_*()
> routines. I was procrastinating at the time and said I'd have a look at
> it, so here I am.
> 
> The thinking is that on many platforms that use the of_() routines
> OpenFirmware is not involved at all, this is true even on many powerpc
> platforms. Also for folks who don't know the OpenFirmware connection it
> reads as "of", as in "a can of worms".
> 
> Personally I'm a bit ambivalent about it, the OF name is a bit wrong so
> it would be nice to get rid of, but it's a lot of churn.
> 
> So I'm hoping people with either say "YES this is a great idea", or "NO
> this is stupid".
> 
> As step one I've just renamed as many routines as I could find to see
> what the resulting patch looks like, so we can quantify the churn. I
> also did device.of_node, which is used quite a bit.
> 
> Thoughts?

I'm looking at it the other way. There are inconsistencies in naming of
symbols and files we definitely should clean up. Since we're doing that,
let's take the opportunity to move from of* to dt*. With multiple
architectures adding device tree support, this is about the last chance
to do this without impacting too many people.
-- 
David VL
