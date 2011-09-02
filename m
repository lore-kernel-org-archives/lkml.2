Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1IBQhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:37:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55526 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab1IBQhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:37:10 -0400
Date: Fri, 2 Sep 2011 09:37:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next RCU complaint during boot
Message-ID: <20110902163706.GA2319@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <8867.1314894817@turing-police.cc.vt.edu>
 <20110902014424.GB2405@linux.vnet.ibm.com>
 <20110902015330.GA28121@somewhere.redhat.com>
 <6595.1314979603@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6595.1314979603@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 12:06:43PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 02 Sep 2011 03:53:32 +0200, Frederic Weisbecker said:
> > On Thu, Sep 01, 2011 at 06:44:24PM -0700, Paul E. McKenney wrote:
> 
> > > This is a bug where someone uses RCU at a time when RCU has been told
> > > that the CPU is in dyntick-idle mode.  Frederic Weisbecker has some
> > > patches that should address this.
> > 
> > Yep, see there: https://lkml.org/lkml/2011/8/20/81
> 
> Hmm.. .would test, but didn't apply cleanly to -next from Wednesday.  Of course,
> I was trying to do it before corn flakes, so I probably got the patches out of order.
> WIll re-try this evening if I get a chance.

I need to queue those patches anyway.  With luck they will hit -rcu by
the end of the weekend.

							Thanx, Paul
