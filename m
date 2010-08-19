Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0HSKYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:24:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:48099 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0HSKYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:24:45 -0400
Subject: Re: 64-bit ppc rwsem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20100818.222925.233689776.davem@davemloft.net>
References: <1282107803.22370.173.camel@pasglop>
	 <20100817.222818.193699062.davem@davemloft.net>
	 <1282195403.22370.296.camel@pasglop>
	 <20100818.222925.233689776.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 20:24:19 +1000
Message-ID: <1282213459.22370.357.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 22:29 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Thu, 19 Aug 2010 15:23:23 +1000
> 
> > Similar here, but using atomic_long_t instead so it works for 32-bit too
> > for me. I suppose we could make that part common indeed.
> > 
> > What about asm-generic/rwsem-atomic.h  or rwsem-cmpxchg.h ?
> 
> Using rwsem-cmpxchg.h sounds best I guess.

Ok, I'll send a new patch tomorrow that does that.

Cheers,
Ben.


