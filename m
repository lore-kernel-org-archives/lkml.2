Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761088Ab2CPKU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:20:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:32900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760112Ab2CPKU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:20:26 -0400
Message-ID: <1331893215.18960.228.camel@twins>
Subject: Re: cpu_active vs pcrypt & padata
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: steffen.klassert@secunet.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 11:20:15 +0100
In-Reply-To: <20120316.031644.577275447313181686.davem@davemloft.net>
References: <1331892788.18960.227.camel@twins>
	 <20120316.031644.577275447313181686.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 03:16 -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 16 Mar 2012 11:13:08 +0100
> 
> > Also, wth is all this kernel/padata.c stuff? There's next to no useful
> > comment in there and the only consumer seems to be pcrypt, does that
> > really need to be in kernel/ ?
> 
> There's really nothing specific to crypto in that padata.c file,
> anything trying to compute things in parallel with some kind
> of converging synchronization points can use that code.

So why isn't anybody else using that? Don't the block/fs people need
similar things?
