Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1H2RBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:01:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51700 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1H2RBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:01:51 -0400
Date: Mon, 29 Aug 2011 19:01:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 04/32] nohz: Separate idle sleeping time accounting from
 nohz switching
Message-ID: <20110829170143.GB9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-5-git-send-email-fweisbec@gmail.com>
 <1314627809.2816.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314627809.2816.63.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:23:29PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > +extern void tick_nohz_exit_idle(void);
> > +extern void tick_nohz_irq_exit(void); 
> 
> For consistencies sake, pick either tick_nohz_exit_*() or
> tick_nohz_*_exit() but don't go mix and match (I prefer the former).

Agreed, I will.

> Also, there isn't a matching irq_enter() callback..

Yeah, probably tick_check_nohz() should be renamed accordingly.
