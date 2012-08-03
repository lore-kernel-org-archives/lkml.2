Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2HCVET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:04:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43147 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2HCVES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:04:18 -0400
Date: Fri, 3 Aug 2012 23:04:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] code_domain: New code domain tracking susbsystem
Message-ID: <20120803210407.GB1894@somewhere.redhat.com>
References: <1344006145-26115-1-git-send-email-fweisbec@gmail.com>
 <1344006145-26115-2-git-send-email-fweisbec@gmail.com>
 <20120803194536.GA2974@gmail.com>
 <1344024579.27983.115.camel@gandalf.stny.rr.com>
 <20120803203144.GJ2474@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803203144.GJ2474@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 01:31:44PM -0700, Paul E. McKenney wrote:
> On Fri, Aug 03, 2012 at 04:09:39PM -0400, Steven Rostedt wrote:
> > On Fri, 2012-08-03 at 21:45 +0200, Ingo Molnar wrote:
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > Create a new subsystem that handles the probing on kernel 
> > > > boundaries to keep track of the transitions between code 
> > > > domains with two basic initial domains: user or kernel.
> > > 
> > > To do a bit more bike shed painting, I'd call it "context 
> > > tracking" - user mode, kernel mode (guest mode, etc.).
> > > 
> > > The term 'code domain' would bring up blank stares from most 
> > > kernel developers, me thinks.
> > 
> > Heh, that would be a second new term I heard this week for context.
> > Earlier, I noticed that Paul McKenney called it 'levels'. So now there's
> > four names:
> > 
> > user/kernel context
> > user/kernel state
> > user/kernel level
> > user/kernel domain
> > 
> > And we could probably add a fifth:
> > 
> > user/kernel mode
> 
> Plus:
> 
> user/kernel space
> 
> > ;-)
> 
> Then there is "supervisor", "system", "privileged", and who knows what
> all else for "kernel".  And "application" and "problem" and probably
> others for "user".

Hehe.

Ok I agree that domain already has a biased meaning in the kernel.

So I'm going to respin with code_context_tracking.

If anybody oppose, please raise your hand.
