Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2HGNcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:32:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:63871 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab2HGNcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:32:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="194215900"
Date: Tue, 7 Aug 2012 21:32:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Avi Kivity <avi@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
Message-ID: <20120807133225.GA8413@localhost>
References: <1343663105.3847.7.camel@fedora>
 <20120731121759.GA17822@localhost>
 <5017D19B.5080806@redhat.com>
 <1343738627.27983.30.camel@gandalf.stny.rr.com>
 <5017D4AB.3090107@redhat.com>
 <1343740419.27983.33.camel@gandalf.stny.rr.com>
 <20120731234336.GA5526@localhost>
 <1343778699.27983.70.camel@gandalf.stny.rr.com>
 <20120731235725.GB5673@localhost>
 <1344346173.6935.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344346173.6935.4.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 09:29:33AM -0400, Steven Rostedt wrote:
> On Wed, 2012-08-01 at 07:57 +0800, Fengguang Wu wrote:
> > > 
> > > What was the next lines? I bet you it was "PASSED". Which means it did
> > > not fail. This is the second bug you found that has to do with RCU being
> > > called in 'idle'. The one that Paul posted a patch for.
> > 
> > Yeah, PASSED!
> 
> I have this patch queued for 3.7. Can I add your 'Tested-by' for it.

Yes, please. Thanks!

Thanks,
Fengguang

> > [    2.898070]  [<8117ea5e>] time_hardirqs_on+0x1de/0x220
> > [    2.898070]  [<81013313>] ? default_idle+0x593/0xc30
> > [    2.898070]  [<81109d6d>] trace_hardirqs_on_caller+0x2d/0x380
> > [    2.898070]  [<8110a0e7>] trace_hardirqs_on+0x27/0x40
> > [    2.898070]  [<81013313>] default_idle+0x593/0xc30
> > [    2.898070]  [<8101692d>] cpu_idle+0x2dd/0x390
> > [    2.898070]  [<817fbe97>] start_secondary+0x44b/0x460
> > [    3.150115] PASSED
> > [    3.390079] Testing tracer function_graph: PASSED
> > 
> > I'll test Paul's patch on top of yours right away.
> > 
> > Thanks,
> > Fengguang
> 
