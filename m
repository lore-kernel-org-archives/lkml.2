Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab2I1Mjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:39:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43127 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2I1Mjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:39:44 -0400
Date: Fri, 28 Sep 2012 14:39:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: manual merge of the tip tree with the rr tree
Message-ID: <20120928123931.GA12843@somewhere.redhat.com>
References: <20120928133341.5697fbecc1674b2143101f52@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928133341.5697fbecc1674b2143101f52@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 01:33:41PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in arch/Kconfig
> between commit 9a9d5786a5e7 ("Make most arch asm/module.h files use
> asm-generic/module.h") from the rr tree and commits fdf9c356502a
> ("cputime: Make finegrained irqtime accounting generally available") and
> 2b1d5024e17b ("rcu: Settle config for userspace extended quiescent
> state") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good. Thanks.
