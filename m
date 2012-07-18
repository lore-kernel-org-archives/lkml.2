Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2GRXyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 19:54:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40175 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2GRXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 19:54:09 -0400
Date: Wed, 18 Jul 2012 16:54:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 0/7] Per cpu thread hotplug infrastructure - V3
Message-ID: <20120718235402.GP2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120716103749.122800930@linutronix.de>
 <20120716152224.GF2403@linux.vnet.ibm.com>
 <5006F434.9010707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5006F434.9010707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071823-7282-0000-0000-00000B11F429
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 11:06:52PM +0530, Srivatsa S. Bhat wrote:
> On 07/16/2012 08:52 PM, Paul E. McKenney wrote:
> > On Mon, Jul 16, 2012 at 10:42:34AM -0000, Thomas Gleixner wrote:
> >> The following series implements the infrastructure for parking and
> >> unparking kernel threads to avoid the full teardown and fork on cpu
> >> hotplug operations along with management infrastructure for hotplug
> >> and users.
> >>
> >> Changes vs. V2:
> >>
> >>  Use callbacks for all functionality. Thanks to Rusty for pointing
> >>  that out. It makes the use sites nice and simple and keeps all the
> >>  code which would be duplicated otherwise on the core.
> > 
> > Hello, Thomas,
> > 
> > What version should I apply this patchset to?  I tried v3.5-rc7, but
> > got lots of warnings (one shown below) and the watchdog patch did not
> > apply.
> > 
> 
> Hi Paul,
> 
> This patchset applies cleanly on Thomas' smp/hotplug branch in the -tip
> tree.

Thank you, Srivatsa, works much better.  Still get "scheduling while
atomic", looking into that.

I suppose I should have been able to guess where it was based...
Ah, well...

							Thanx, Paul

