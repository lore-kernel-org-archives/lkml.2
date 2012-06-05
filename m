Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2FEXq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:46:56 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60935 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FEXqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:46:54 -0400
Date: Tue, 5 Jun 2012 16:46:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] rcu: Extended quiescent state for adaptive nohz
Message-ID: <20120605234640.GY2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
 <20120604181313.GL2490@linux.vnet.ibm.com>
 <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
 <20120604210709.GO2490@linux.vnet.ibm.com>
 <20120605103055.GA4553@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120605103055.GA4553@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060523-7408-0000-0000-0000059BD6EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 12:31:00PM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 04, 2012 at 02:07:09PM -0700, Paul E. McKenney wrote:
> > On Mon, Jun 04, 2012 at 09:06:22PM +0200, Frederic Weisbecker wrote:
> > > 2012/6/4 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > > > On Mon, Jun 04, 2012 at 02:08:26PM +0200, fweisbec@gmail.com wrote:
> > > >> From: Frederic Weisbecker <fweisbec@gmail.com>
> > > >>
> > > >> Paul, Ingo,
> > > >>
> > > >> This is a rebase of the nohz cpusets RCU APIs on top of Paul's latest
> > > >> -rcu (rcu/core) branch.
> > > >>
> > > >> I have only built tested it yet, I need to do a full rebase of my
> > > >> tree to test it in practice. But I wanted to show you how it looks
> > > >> like first.
> > > >>
> > > >> I also wonder if we can set that to a tree somewhere. Ingo suggested
> > > >> to set up a tree on -tip to apply the uncontroversial part of nohz
> > > >> cpusets patches and iterate from there. I think it would accelerate
> > > >> everything if we start doing that.
> > > >
> > > > It would probably be best to put these two in the -rcu set in order to
> > > > avoid conflicts with possible further RCU_FAST_NO_HZ work.  I could
> > > > push this to -tip early, if that would help.
> > > 
> > > But then these APIs are going to be upstream on 3.6
> > > Is that ok for you even if they don't have any upstream user?
> > > We can ifdef it.
> > 
> > I figured on maintaining a separate rcu/idle topic branch that I would
> > merge locally for building and testing, but which I would not push
> > to rcu/next.  If Ingo agrees, I can push separately to -tip so that it
> > does not go upstream until you are ready, at which point I would merge
> > it into rcu/next.
> > 
> > Seem reasonable, or would something else work better?
> 
> Sounds very good!

Here you go:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/idle

							Thanx, Paul

