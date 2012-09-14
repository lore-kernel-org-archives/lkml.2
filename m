Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2INQyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:54:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45593 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325Ab2INQyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:54:18 -0400
Date: Fri, 14 Sep 2012 17:53:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/31] arm64: Cache maintenance routines
Message-ID: <20120914165331.GA2927@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
 <201209071928.09999.arnd@arndb.de>
 <20120910164815.GB8238@arm.com>
 <alpine.LFD.2.02.1209101322140.28681@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1209101322140.28681@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 06:29:21PM +0100, Nicolas Pitre wrote:
> On Mon, 10 Sep 2012, Catalin Marinas wrote:
> 
> > On Fri, Sep 07, 2012 at 08:28:09PM +0100, Arnd Bergmann wrote:
> > > On Friday 07 September 2012, Catalin Marinas wrote:
> > > > +
> > > > +/*
> > > > + *	dmac_inv_range(start,end)
> > > 
> > > all of these appear to be unused now. Can you remove them?
> > 
> > They aren't currently used but I expect some partners to make use of
> > them on their private development. I could drop them from the upstream
> > branch temporarily.
> 
> Depends.  If your expectation from those partners is a real probability 
> then it is best to keep a skeleton in place for them to use, otherwise 
> they might get ... creative.  If this is just wild speculation then you 
> should drop it.

I dropped them for now since there is no API using those functions. But
I have a feeling they will be needed at some point (so I'll keep the
patches around).

-- 
Catalin
