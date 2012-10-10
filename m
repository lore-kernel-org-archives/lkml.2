Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab2JKA1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:27:37 -0400
Received: from ozlabs.org ([203.10.76.45]:43383 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933470Ab2JKA1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:27:31 -0400
Date: Thu, 11 Oct 2012 10:06:20 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Warner Losh <imp@bsdimp.com>
Cc: Scott Wood <scottwood@freescale.com>, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121010230620.GE28467@truffula.fritz.box>
References: <1349827466.26044.16@snotra>
 <ADE80D65-5170-4A8E-8D90-29161F8DB3BB@bsdimp.com>
 <20121010072401.GA28467@truffula.fritz.box>
 <0E46FFF5-4500-47D6-8CEA-FA252D87E585@bsdimp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0E46FFF5-4500-47D6-8CEA-FA252D87E585@bsdimp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 08:41:45AM -0600, Warner Losh wrote:
> On Oct 10, 2012, at 1:24 AM, David Gibson wrote:
> > On Tue, Oct 09, 2012 at 10:43:50PM -0600, Warner Losh wrote:
[snip]
> >> .h files include both structs and defines, which are fine for
> >> ordinary C code, but problematic in this context.
> > 
> > Right, cpp should be invoked with similar options to the way it's done
> > for asm files which have the same problem.  I'm not sure if the
> > current patch does so.
> 
> I know the current dtc code is very careful to license itself in a
> very agnostic way.  Would including files, possibly from the Linux
> kernel, pose any kind of license issue?  Or does the fact that many
> (but not all) .dts files being apparently licensed GPL already make
> this a moot point?  Or does it not matter since this is an interface
> and declaration of information, which likely isn't creative enough
> to receive to copyright protection....  Or is this a can of worms
> best avoided :)

Um... what?  The licensing of dtc itself has nothing to do with the
licensing of the dts files used as input to it.  Those, and their
includes, would be licensed GPLv2 just like the rest of the kernel,
I'd expect.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
