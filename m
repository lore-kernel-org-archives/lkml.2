Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0HJJhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:37:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:49855 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0HJJhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:37:09 -0400
Subject: Re: 2.6.32 swapper allocation failure with plenty of memory
 available
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.1008100757470.19930@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1008100757470.19930@uplift.swm.pp.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 19:37:02 +1000
Message-ID: <1281433022.28245.201.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 08:05 +0200, Mikael Abrahamsson wrote:
> Hi.
> 
> Yesterday my Ubuntu 10.04 machine with their 2.6.32 (amd64) kernel, under 
> a lot of disk IO and network stress stopped responding. I thought it had 
> frozen completely, but ~2 hours later it came back to life.
> 
> When I logged in I saw a lot of "swapper allocation failure" and r8169 
> timeouts in dmesg (first time I've seen this cause network instability 
> like this, but it's also the first motherboard I've tested with that has a 
> r8169 NIC).
 .../...

I noticed that on a completely different setup as well... 2.6.32 tend to
have a hard time servicing the skb allocations for demanding network
drivers.

Probably some threshold in the VM that might want tuning...

Cheers,
Ben.


