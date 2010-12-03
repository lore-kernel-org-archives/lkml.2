Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0LCQzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 11:55:19 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63452 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431Ab0LCQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 11:55:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHev+Ex5LdV4/2dsb2JhbACjNXLDIoVIBA
Date: Sat, 4 Dec 2010 03:55:08 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: David Miller <davem@davemloft.net>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
Message-ID: <20101203165508.GC3346@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <20101201.100330.226770021.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201.100330.226770021.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:03:30AM -0800, David Miller wrote:
> From: Nick Piggin <npiggin@kernel.dk>
> Date: Sat, 27 Nov 2010 21:15:58 +1100
> 
> > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working
> 
> Just want to say that I've been running this code for the past few days on
> my 128 cpu box and it seems quite sturdy.
> 
> If there are any kinds of vfs benchmarks you want me to run on this
> machine both with and without the scaling changes, just let me know.

Hi Dave, great, thanks!

I am mostly interested in single-thread performance on different ISAs
and different microarchitectures.

Microbenchmarks are easy, I attached a couple of quick ones I use in
an offline mail.

Single-threaded (preloadindex=false), cached and uncached, git diff on
an unmodified tree is slightly more real world.

And then anything else you can think of.

Thanks,
Nick

