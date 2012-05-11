Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102Ab2EKV3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:29:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab2EKV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:29:33 -0400
Date: Fri, 11 May 2012 14:29:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: mgorman@suse.de, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 00/17] Swap-over-NBD without deadlocking V10
Message-Id: <20120511142932.af7851bd.akpm@linux-foundation.org>
In-Reply-To: <20120511.172339.2007927803884694483.davem@davemloft.net>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<20120511.010445.1020972261904383892.davem@davemloft.net>
	<20120511154540.GV11435@suse.de>
	<20120511.172339.2007927803884694483.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 17:23:39 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Mel Gorman <mgorman@suse.de>
> Date: Fri, 11 May 2012 16:45:40 +0100
> 
> > From my point of view, the ideal would be that all the patches go
> > through akpm's tree or yours but that probably will cause merge
> > difficulties.
> > 
> > Any recommendations?
> 
> I know there will be networking side conflicts very soon, it's not a
> matter of 'if' but 'when'.
> 
> But the trick is that I bet the 'mm' and 'slab' folks are in a similar
> situation.
> 
> In any event I'm more than happy to take it all in my tree.

I guess either is OK.  The main thing is to get it all reviewed and
tested, after all.

I can take all the patches once it's all lined up and everyone is
happy.  If the net bits later take significant damage then I can squirt them
at you once the core MM bits are merged.  That would give you a few
days to check them over and get them into Linus.  If that's a problem,
we can hold the net bits over for a cycle.

That's all assuming that the core MM parts are mergeable without the
net parts being merged.  I trust that's the case!
