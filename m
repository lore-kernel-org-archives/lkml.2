Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1K2SHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:07:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53539 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab1K2SHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:07:41 -0500
Date: Tue, 29 Nov 2011 19:07:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] rcu: Make new RCU dynticks API work with nohz cpusets
Message-ID: <20111129180731.GC20387@somewhere>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <20111129052225.GB14546@leaf>
 <20111129054342.GA2375@linux.vnet.ibm.com>
 <20111129084831.GA21034@leaf>
 <20111129174448.GG2331@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129174448.GG2331@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:44:48AM -0800, Paul E. McKenney wrote:
> On Tue, Nov 29, 2011 at 12:48:31AM -0800, Josh Triplett wrote:
> > On Mon, Nov 28, 2011 at 09:43:42PM -0800, Paul E. McKenney wrote:
> > > On Mon, Nov 28, 2011 at 09:22:25PM -0800, Josh Triplett wrote:
> > > > On Mon, Nov 28, 2011 at 10:24:43PM +0100, Frederic Weisbecker wrote:
> > > > > Hi Paul,
> > > > > 
> > > > > This is an attempt to make the current RCU dynticks API
> > > > > working with the nohz cpusets.
> > > > > 
> > > > > I believe the two first patches could be pushed in your trees.
> > > > > Patches 3 and 4 are rather something I plan to apply in mine,
> > > > > given they are not needed upstream yet.
> > > > > 
> > > > > Waiting for your comments.
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > > Frederic Weisbecker (4):
> > > > >   rcu: Don't check irq nesting from rcu idle entry/exit
> > > > >   rcu: Irq nesting is always 0 on rcu_enter_idle_common
> > > > >   rcu: New rcu_user_enter() and rcu_user_exit() APIs
> > > > >   rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
> > > > 
> > > > For the whole series:
> > > > 
> > > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > 
> > > Thank you, Josh!
> > > 
> > > Does that cover the conflict-resolved versions of the first two?
> > > 
> > > o	https://lkml.org/lkml/2011/11/28/626
> > > o	https://lkml.org/lkml/2011/11/28/624
> > 
> > Yes, for the ones with Frederic's further eagle-eyed fix.
> 
> Right, https://lkml.org/lkml/2011/11/28/626 above rather than my
> erroneous https://lkml.org/lkml/2011/11/28/621.
> 
> Though I thought it was falcon-eyed rather than eagle-eyed.  ;-)

Peregrine falcon-eyed more precisely. Then I can stoop over 300 km/h
right to the bug!
