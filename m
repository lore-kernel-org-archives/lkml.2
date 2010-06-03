Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0FCSaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:30:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59988 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0FCSai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:30:38 -0400
Date: Thu, 3 Jun 2010 19:30:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603183030.GY31073@ZenIV.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603181010.GA25779@flint.arm.linux.org.uk>
 <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
 <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:21:59AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 3 Jun 2010, Daniel Walker wrote:
> > 
> > I don't see how we can do without defconfigs altogether tho. I mean , if
> > you want to run a Beagle board or a Nexus one we can't just give the
> > users a slim ARM config and let them troll through 1000's of drivers
> > trying to find just those ones that work on their given board.
> 
> Well, you also don't need the full defconfig's with the kernel.
> 
> Right now they are just noise. They actually _hide_ things, because 
> diffstat (and dirstat) information becomes pointless, and the diffs become 
> totally unreadable by any human (trust me - when the choice is between 
> "search for next relevant diff" or "blast it, I can't be bothered with 
> walking through this crap", quite often the choice is the latter).
> 
> So they are an actual burden on real development.

BTW, can't we switch to processing them with cpp?  That'd cut down on the
churn big way, AFAICS, not to mention reducing the odds of missing some
of them on such changes, etc.
