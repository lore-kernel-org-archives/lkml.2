Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0FHTHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:07:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab0FHTHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:07:31 -0400
Date: Tue, 8 Jun 2010 21:07:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       kosaki.motohiro@jp.fujitsu.com, benh@kernel.crashing.org,
       paulus@samba.org, sparse@chrisli.org
Subject: Re: [GIT PULL] rcu: finalize debugobjects, first round of RCU sparse
 pointer checks
Message-ID: <20100608190709.GC25985@elte.hu>
References: <20100601165034.GA9522@linux.vnet.ibm.com>
 <20100608180701.GJ11585@elte.hu>
 <20100608183726.GA15508@elte.hu>
 <20100608185128.GF2397@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608185128.GF2397@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Jun 08, 2010 at 08:37:26PM +0200, Ingo Molnar wrote:
> > 
> > i have hit this build failure:
> > 
> >  security/selinux/netnode.c: In function 'sel_netnode_insert':
> >  security/selinux/netnode.c:186: error: implicit declaration of function 'INIT_RCU_HEAD'
> > 
> > When merging your new bits into tip:master. Config attached.
> > 
> > Maybe we should try a .35 base after all? ;-)
> 
> I will forward-port, test, and resubmit.  ;-)

thanks! :-)

	Ingo
