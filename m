Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab0JBQlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:41:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38025 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab0JBQlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:41:17 -0400
Date: Sat, 2 Oct 2010 22:11:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] taskstats: Cleanup patches
Message-ID: <20101002164110.GA7896@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100928142058.796669370@linux.vnet.ibm.com>
 <20100928135117.4fdd5799.akpm@linux-foundation.org>
 <20100929075044.GF4261@balbir.in.ibm.com>
 <20100929110113.374e8651.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100929110113.374e8651.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2010-09-29 11:01:13]:

> On Wed, 29 Sep 2010 13:20:44 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * Andrew Morton <akpm@linux-foundation.org> [2010-09-28 13:51:17]:
> > 
> > > On Tue, 28 Sep 2010 16:20:58 +0200
> > > Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> > > 
> > > > Hello Andrew,
> > > > 
> > > > It would be great, if you could accept the taskstats cleanup patches that
> > > > are the prerequisite for the taskstats precise accounting patches. The
> > > > patches do not add any new functionality. I think they make the code better
> > > > readable and extensible:
> > > > * 01/02: taskstats: Separate taskstats commands
> > > > * 02/02: taskstats: Split fill_pid function
> > > > 
> > > 
> > > Sure.
> > > 
> > > I've been sitting on a couple of taskstats patches for ages.  Mel's
> > > delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
> > > and Jeff's delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch.
> > > 
> > > I have notes against both of these indicating that Balbir had concerns
> > > and as far as I know those concerns remain unresolved.  So I'll drop
> > > those patches now - can you guys please reactivate them if you still
> > > think we should be making these changes?
> > > 
> > 
> > Hi, Andrew,
> > 
> > My concern with Jeff's patch was that it might break existing
> > applications. He clarified it does not, I had requested for a version
> > bump since the patches change some definitions
> > 
> > I had no concerns (IIRC) with Mel's patches. Mel wanted me to
> > implement the "-c" option we had earlier.
> > 
> 
> hm, OK, thanks, I requeued them for 2.6.37.

Thanks, Andrew!

-- 
	Three Cheers,
	Balbir
