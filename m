Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2HCUdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 16:33:05 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40394 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2HCUdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 16:33:01 -0400
Date: Fri, 3 Aug 2012 13:31:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
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
Message-ID: <20120803203144.GJ2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1344006145-26115-1-git-send-email-fweisbec@gmail.com>
 <1344006145-26115-2-git-send-email-fweisbec@gmail.com>
 <20120803194536.GA2974@gmail.com>
 <1344024579.27983.115.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344024579.27983.115.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080320-5518-0000-0000-00000691D0BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 04:09:39PM -0400, Steven Rostedt wrote:
> On Fri, 2012-08-03 at 21:45 +0200, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Create a new subsystem that handles the probing on kernel 
> > > boundaries to keep track of the transitions between code 
> > > domains with two basic initial domains: user or kernel.
> > 
> > To do a bit more bike shed painting, I'd call it "context 
> > tracking" - user mode, kernel mode (guest mode, etc.).
> > 
> > The term 'code domain' would bring up blank stares from most 
> > kernel developers, me thinks.
> 
> Heh, that would be a second new term I heard this week for context.
> Earlier, I noticed that Paul McKenney called it 'levels'. So now there's
> four names:
> 
> user/kernel context
> user/kernel state
> user/kernel level
> user/kernel domain
> 
> And we could probably add a fifth:
> 
> user/kernel mode

Plus:

user/kernel space

> ;-)

Then there is "supervisor", "system", "privileged", and who knows what
all else for "kernel".  And "application" and "problem" and probably
others for "user".

							Thanx, Paul

