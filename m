Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0IDObq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:31:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54268 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0IDObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:31:45 -0400
Date: Sat, 4 Sep 2010 15:31:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
Message-ID: <20100904143109.GA16462@n2100.arm.linux.org.uk>
References: <1282922978.5075.13.camel@m0nster> <1282925072.26355.61.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282925072.26355.61.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 05:04:32PM +0100, Catalin Marinas wrote:
> On Fri, 2010-08-27 at 16:29 +0100, Daniel Walker wrote:
> > > In general, I would have liked a different way (still ID-based) of
> > > handling such issues without duplicating the whole structure. But I see
> > > this becoming the standard as proc-v6.S follows it as well.
> > 
> > This whole thing was something Russell specifically asked for (and
> > practically wrote for me).
> 
> Yes, I know and I'm not saying that you should change it in this patch.
> It's just that I would have liked to only duplicate the setup function
> rather than the whole procinfo structure.

If you think about it, the only way to do that is to make things even
more complicated than they already are by separating out the rest of
the structure from the ID, mask, and setup functions.  At that point,
what if someone has just one change to the other values in the structure?
They'll have the same complaint as you have, and they'll want it split
in an entirely different way.
