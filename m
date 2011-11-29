Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1K2Fnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:43:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46690 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1K2Fns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:43:48 -0500
Date: Mon, 28 Nov 2011 21:43:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] rcu: Make new RCU dynticks API work with nohz
 cpusets
Message-ID: <20111129054342.GA2375@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <20111129052225.GB14546@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129052225.GB14546@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112905-9360-0000-0000-0000010DB951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 09:22:25PM -0800, Josh Triplett wrote:
> On Mon, Nov 28, 2011 at 10:24:43PM +0100, Frederic Weisbecker wrote:
> > Hi Paul,
> > 
> > This is an attempt to make the current RCU dynticks API
> > working with the nohz cpusets.
> > 
> > I believe the two first patches could be pushed in your trees.
> > Patches 3 and 4 are rather something I plan to apply in mine,
> > given they are not needed upstream yet.
> > 
> > Waiting for your comments.
> > 
> > Thanks.
> > 
> > Frederic Weisbecker (4):
> >   rcu: Don't check irq nesting from rcu idle entry/exit
> >   rcu: Irq nesting is always 0 on rcu_enter_idle_common
> >   rcu: New rcu_user_enter() and rcu_user_exit() APIs
> >   rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
> 
> For the whole series:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you, Josh!

Does that cover the conflict-resolved versions of the first two?

o	https://lkml.org/lkml/2011/11/28/626
o	https://lkml.org/lkml/2011/11/28/624

							Thanx, Paul

