Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1FMOC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:02:27 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53359 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845Ab1FMOC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:02:26 -0400
Date: Mon, 13 Jun 2011 10:02:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Cui, Dexuan" <dexuan.cui@intel.com>,
        "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rp@svcs.cs.pdx.edu" <rp@svcs.cs.pdx.edu>
Subject: Re: [ltt-dev] [RELEASE] Userspace RCU 0.6.0
Message-ID: <20110613140223.GB29349@Krystal>
References: <20110611011417.GA8722@Krystal> <1865303E0DED764181A9D882DEF65FB699650124A2@shsmsx502.ccr.corp.intel.com> <20110613042340.GH2212@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613042340.GH2212@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:00:49 up 201 days, 19:03,  7 users,  load average: 0.20, 0.08,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Jun 13, 2011 at 10:06:09AM +0800, Cui, Dexuan wrote:
[...]
> > Hi Mathieu,
> > The release can't build in my side:
> > 
> > $ tar -jxf userspace-rcu-0.6.0.tar.bz2 && cd userspace-rcu-0.6.0 && ./configure && make
> > 
> > make  all-recursive
> > make[1]: Entering directory `/home/dcui/userspace-rcu-0.6.0'
> > Making all in .
> > make[2]: Entering directory `/home/dcui/userspace-rcu-0.6.0'
> >   CC     wfqueue.lo
> >   CC     wfstack.lo
> >   CC     rculfqueue.lo
> >   CC     rculfstack.lo
> >   CCLD   liburcu-cds.la
> >   CC     urcu.lo
> > urcu.c:438:32: error: urcu-call-rcu-impl.h: No such file or directory
> > urcu.c:439:29: error: urcu-defer-impl.h: No such file or directory
> > make[2]: *** [urcu.lo] Error 1
> > make[2]: Leaving directory `/home/dcui/userspace-rcu-0.6.0'
> > make[1]: *** [all-recursive] Error 1
> > make[1]: Leaving directory `/home/dcui/userspace-rcu-0.6.0'
> > make: *** [all] Error 2
> > 
> > Can you please have a look?
> 
> I get the same thing from the tarball.  But the git tree works just fine,
> so my guess is that the tarball creation left out a couple of files.

Indeed, I missed those two headers in the Makefile.am EXTRA_DIST. I just
released 0.6.1, which fixes this issue. I've made sure the tarball
builds fine.

Thanks for reporting this so quickly!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
