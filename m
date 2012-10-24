Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169Ab2JXUSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:18:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41937 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789Ab2JXUSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:18:04 -0400
Date: Wed, 24 Oct 2012 13:15:39 -0700
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121024201539.GD2340@swordfish>
References: <20121017034918.GA13295@redhat.com>
 <20121024164235.GA2467@swordfish>
 <20121024180608.GA22840@redhat.com>
 <20121024182111.GA2340@swordfish>
 <20121024185230.GB5025@redhat.com>
 <20121024191716.GB2340@swordfish>
 <20121024194101.GG2465@linux.vnet.ibm.com>
 <20121024195033.GC2340@swordfish>
 <20121024201117.GJ2465@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024201117.GJ2465@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/24/12 13:11), Paul E. McKenney wrote:
> > > > 
> > > > sorry, I meant idle from RCU point of view:
> > > > 
> > > > int rcu_is_cpu_idle(void)
> > > > {
> > > >          return !rcu_dynticks_nesting;
> > > > }
> > > 
> > > Hmmm...  This reproduces on UP builds, then?
> > 
> > I'll compile UP build (will offlining of N-1 CPUs do the trick?).
> 
> Oh -- you quoted the Tiny RCU (CONFIG_SMP=n) variant of rcu_is_cpu_idle(),

sorry, that was just an 'illustration'.

	-ss

> so I just thought that you were reproducing on CONFIG_SMP=n.  You would
> have to actually rebuild the kernel to get the different version.
> 
> But never mind!  RCU_USER_QS depends on CONFIG_SMP=y, so my question
> was irrelevant.
> 
> 							Thanx, Paul
> 
