Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0FCS0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:26:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab0FCS0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:26:39 -0400
Date: Thu, 3 Jun 2010 11:21:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Walker <dwalker@codeaurora.org>
cc: Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>  <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>  <20100603181010.GA25779@flint.arm.linux.org.uk> <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Daniel Walker wrote:
> 
> I don't see how we can do without defconfigs altogether tho. I mean , if
> you want to run a Beagle board or a Nexus one we can't just give the
> users a slim ARM config and let them troll through 1000's of drivers
> trying to find just those ones that work on their given board.

Well, you also don't need the full defconfig's with the kernel.

Right now they are just noise. They actually _hide_ things, because 
diffstat (and dirstat) information becomes pointless, and the diffs become 
totally unreadable by any human (trust me - when the choice is between 
"search for next relevant diff" or "blast it, I can't be bothered with 
walking through this crap", quite often the choice is the latter).

So they are an actual burden on real development.

		Linus
