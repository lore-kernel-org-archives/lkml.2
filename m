Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2HUHLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:11:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2HUHLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:11:12 -0400
Date: Tue, 21 Aug 2012 08:05:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Sage Weil <sage@inktank.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net, eric.dumazet@gmail.com,
        sebastian@breakpoint.cc, cl@linux.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: regression with poll(2)
Message-ID: <20120821070515.GA1657@suse.de>
References: <alpine.DEB.2.00.1208151226250.15721@cobra.newdream.net>
 <alpine.DEB.2.00.1208191051150.15570@cobra.newdream.net>
 <20120820090443.GA3275@suse.de>
 <alpine.DEB.2.00.1208200930510.26904@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1208200930510.26904@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 09:54:59AM -0700, Sage Weil wrote:
> > <SNIP>
> > 
> > > I've retested several times and confirmed that this change leads to the 
> > > breakage, and also confirmed that reverting it on top of -rc1 also fixes 
> > > the problem.
> > > 
> > > I've also added some additional instrumentation to my code and confirmed 
> > > that the process is blocking on poll(2) while netstat is reporting 
> > > data available on the socket.
> > > 
> > > What can I do to help track this down?
> > > 
> > 
> > Can the following patch be tested please? It is reported to fix an fio
> > regression that may be similar to what you are experiencing but has not
> > been picked up yet.
> 
> This patch appears to resolve things for me as well, at least after a 
> couple of passes.  I'll let you know if I see any further problems come up 
> with more testing.
> 

Thanks very much Sage.

-- 
Mel Gorman
SUSE Labs
