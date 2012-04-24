Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab2DXSuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:50:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17010 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2DXSui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:50:38 -0400
Date: Tue, 24 Apr 2012 14:44:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
Message-ID: <20120424184436.GA14929@phenom.dumpdata.com>
References: <20120420122120.097464672@linutronix.de>
 <4F916AF3.7020301@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1204201602330.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1204201602330.2542@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 04:18:04PM +0200, Thomas Gleixner wrote:
> On Fri, 20 Apr 2012, Srivatsa S. Bhat wrote:
> > > This first part moves the idle thread management for non-boot cpus
> > > into the core. fork_idle() is called in a workqueue as it is
> > > implemented in a few architectures already. This is necessary when not
> > > all cpus are brought up by the early boot code as otherwise we would
> > > take a ref on the user task VM of the thread which brings the cpu up
> > > via the sysfs interface.
> > > 
> > 
> > 
> > Do you have a git tree where you have made these patches available?
> > That would be pretty useful, so that we can build on whatever you have
> 
> Not yet, but I'll stick that into a tip/ branch.

Looking at the patch from the Xen side it looks OK. But would like to test
to make sure - is there a git branch I could pull to run this?
