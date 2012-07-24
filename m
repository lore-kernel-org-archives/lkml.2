Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2GXITL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:19:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab2GXITG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:19:06 -0400
Date: Tue, 24 Jul 2012 09:19:03 +0100
From: Mel Gorman <mgorman@suse.de>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [MMTests] Sysbench read-only on ext3
Message-ID: <20120724081903.GL9222@suse.de>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120723211334.GA9222@suse.de>
 <1343096969.7412.21.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1343096969.7412.21.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 04:29:29AM +0200, Mike Galbraith wrote:
> On Mon, 2012-07-23 at 22:13 +0100, Mel Gorman wrote:
> 
> > The backing database was postgres.
> 
> FWIW, that wouldn't have been my choice.  I don't know if it still does,
> but it used to use userland spinlocks to achieve scalability. 

The tests used to support mysql but the code bit-rotted and eventually
got deleted. I'm not going to get into a mysql vs postgres discussion on
which is better :O

Were you thinking of mysql or something else as an alternative?
Completely different test?

> Turning
> your CPUs into space heaters to combat concurrency issues makes a pretty
> flat graph, but probably doesn't test kernels as well as something that
> did not do that.
> 

I did not check the source, but even if it is true then your comments only
applies to testing scalability of locking. If someone really cares to check,
the postgres version was 9.0.4. However, even if they are using user-space
locking, the test is still useful for looking at the IO performance,
page reclaim decisions and so on.

-- 
Mel Gorman
SUSE Labs
