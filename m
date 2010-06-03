Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0FCUO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:14:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab0FCUO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:14:57 -0400
Date: Thu, 3 Jun 2010 13:09:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
cc: Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <20100603194559.GF25779@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org> <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com> <20100603194559.GF25779@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Russell King wrote:
> 
> I already covered that in my (ignored) email where I brought up a
> "STD_CONFIG" config symbol, which could be disabled to turn off all
> these additional "select"s.

I apparently haven't explained myself enough, because what you keep on 
harping on is not something I consider acceptable.

STD_CONFIG is pointless. It's pointless because the solution to what 
you call STD_CONFIG would be to just NOT USING the special Kconfig.xyz 
file at all.

So when I suggest special Kconfig files, they are meant to just generate 
the templates - ie they'd _generate_ what is currently the defconfig 
files. You wouldn't _have_ to use them at all.

If you _had_ to use them, you'd lose the flexibility of Kconfig and asking 
questions. 

		Linus
