Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2LJKNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:13:35 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42761 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab2LJKNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:13:33 -0500
Date: Mon, 10 Dec 2012 15:12:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/45] Automatic NUMA Balancing V7
Message-ID: <20121210094257.GB6348@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1353612353-1576-1-git-send-email-mgorman@suse.de>
 <20121126145800.GK8218@suse.de>
 <20121128134930.GB20087@suse.de>
 <20121207104539.GB22164@linux.vnet.ibm.com>
 <20121210090730.GF1009@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121210090730.GF1009@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121010-9360-0000-0000-00000DBEB2E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Got a chance to run autonuma-benchmark on a 8 node, 64 core machine. 
> > the results are as below. (for each kernel I ran 5 iterations of
> > autonuma-benchmark)
> > 
> 
> Thanks, a test of v10 would also be appreciated. The differences between
> V7 and V10 are small but do include a change in how migrate rate-limiting
> is handled. It is unlikely it'll make a difference to this test but I'd
> like to rule it out.
> 


Yes, have queued it for testing. Will report on completion.


> > KernelVersion: 3.7.0-rc3-mainline_v37rc7()

Please read it as 3.7-rc3 

> 
> What kernel is this? The name begins with 3.7-rc3 but then says
> v37rc7. v37rc7 of what? I thought it might be v3.7-rc7 but it already said
> it's 3.7-rc3 so I'm confused. Would it be possible to base the tests on
> a similar baseline kernel such as 3.7.0-rc7 or 3.7.0-rc8? The



> balancenuma patches should apply and the autonuma patches can be taken
> from the mm-autonuma-v28fastr4-mels-rebase branch in
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git
> 

Yes, for the next set of reports I have based autonuma branch on this
branch.

> Either way, the figures look bad. I'm trying to find a similar machine
> but initially at least I have not had much luck. Can you post the .config
> you used for balancenuma in case I can reproduce the problem on a 4-node
> machine please? Are all the nodes the same size?
> 

No all nodes are not of same size
There are 6 32 GB nodes and 2 64 GB nodes.

Will post the balancenuma config along with results.

-- 
Thanks and Regards
Srikar

