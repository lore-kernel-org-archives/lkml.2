Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2AWVY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:24:29 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22286 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2AWVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:24:28 -0500
Date: Mon, 23 Jan 2012 16:21:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, gregkh@suse.de, rjw@sisk.pl
Subject: Re: v3.3-rc1, regression introduced by "sched, nohz: Implement sched
 group, domain aware nohz idle load balancing" when unplugging CPUs.
Message-ID: <20120123212142.GA29288@phenom.dumpdata.com>
References: <20120123205638.GA8542@phenom.dumpdata.com>
 <1327352449.2446.19.camel@twins>
 <20120123211051.GA10967@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123211051.GA10967@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F1DCFF2.0067,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 04:10:51PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 23, 2012 at 10:00:49PM +0100, Peter Zijlstra wrote:
> > On Mon, 2012-01-23 at 15:56 -0500, Konrad Rzeszutek Wilk wrote:
> > > Not exactly sure how this patch does it, but with this git commit
> > > 0b005cf54eac170a8f22540ab096a6e07bf49e7c, the Linux kernel crashes
> > > if I try to hot unplug VCPUs to the first (initial) domain.
> > > This is found using git bisection, and if I use the kernel compiled
> > > with 69e1e811dcc436a6b129dbef273ad9ec22d095ce (the previous commit)
> > > it works nicely. 
> > 
> > https://lkml.org/lkml/2012/1/19/463
> > 
> > is already on its way...
> 
> Oh, somehow I thought the mce check fixes were already in v3.3-rc1.
> My apologies and will take that patch on a test-spin.

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks!
