Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2B1JwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:52:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab2B1JwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:52:10 -0500
Date: Tue, 28 Feb 2012 10:51:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, nab@linux-iscsi.org,
        jkosina@suse.cz, jj@chaosbits.net, davem@davemloft.net,
        linville@tuxdriver.com, johannes@sipsolutions.net,
        josh@joshtriplett.org, a.p.zijlstra@chello.nl, dhowells@redhat.com,
        Julia.Lawall@lip6.fr, deepthi@linux.vnet.ibm.com,
        neven.m.abou.gazala@intel.com, hughd@google.com
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.4
Message-ID: <20120228095132.GA16511@elte.hu>
References: <20120227172248.GA5338@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227172248.GA5338@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> The major features of this series are making RCU more aggressive about
> entering dyntick-idle mode in order to improve energy efficiency,
> converting a few more call_rcu()s to kfree_rcu()s, applying a number
> of rcutree fixes and cleanups to rcutiny, removing CONFIG_SMP #ifdefs
> from treercu, allowing RCU CPU stall times to be set via sysfs, adding
> CPU-stall capability to rcutorture, adding more RCU-abuse diagnostics,
> updating documentation, and fixing yet more issue located in the
> still-ongoing top-to-bottom inspection of RCU, this time with a special
> focus on the CPU-hotplug code path.

I stuck this nice list into the merge commit, for future 
generations.

> Three of the kfree_rcu() conversions have not yet received 
> acks (s390, tcm_fc, and mac80211), but the maintainers have 
> been CCed on multiple LKML postings and -next testing has not 
> shown any problems.
> 
> These commits have been posted to LKML (https://lkml.org/lkml/2012/2/3/459
> and https://lkml.org/lkml/2012/2/21/228) and have received -next testing.
> They are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

Pulled, thanks a lot Paul!

	Ingo
