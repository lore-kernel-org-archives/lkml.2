Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2FNLWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:22:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39774 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2FNLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:22:51 -0400
Date: Thu, 14 Jun 2012 13:22:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck,Tony" <tony.luck@intel.com>
Subject: Re: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive
 tickless
Message-ID: <20120614112241.GB16848@somewhere>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
 <1339664829.2559.14.camel@twins>
 <20120614111241.GA16848@somewhere>
 <20120614111638.GA16676@gmail.com>
 <alpine.LFD.2.02.1206141321010.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206141321010.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:21:23PM +0200, Thomas Gleixner wrote:
> On Thu, 14 Jun 2012, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > You're right, I should have looked into CONFIG_VIRT_CPU_ACCOUNTING sooner
> > > and see if I can reuse it.
> > > 
> > > I'll try something with that.
> > 
> > Maybe sanitize all the variants under a single set of 
> > wrappers/callbacks?
> 
> Yes, please!

Sure, I'm working in it.
