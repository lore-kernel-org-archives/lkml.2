Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0FCTCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:02:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab0FCTCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:02:01 -0400
Date: Thu, 3 Jun 2010 11:56:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <20100603185333.GD25779@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
 <20100603185333.GD25779@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Russell King wrote:
> 
> No amount of reorganising the Kconfig files into a heirarchial manner
> (which they already are) helps.  Not one bit.  Because they already are.
> That's not where the problem is.

I don't think you read the whole thread.

Earlier on, I explained exactly what I wanted: just add some "select" 
statements to pickt he things you need per the particular target 
configuration. You seem to have missed that part.

In other words, you _can_ encode the information that is in the 
xyz_defconfig files by doing it in Kconfig.xyz files instead. But you do 
it in a human-readable manner. And the hierarchical thing is absolutely 
required for that - otherwise you'd end up with just another form of the 
current xyz_defconfig.

See?

In other words, you should be able to basically use "make allnoconfig" 
together with a Kconfig.xyz file input to select _exactly_ the pieces you 
need, and nothing else.

			Linus
