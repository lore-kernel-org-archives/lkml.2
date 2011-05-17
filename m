Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1EQIKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:10:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54839 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab1EQIKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:10:17 -0400
Date: Tue, 17 May 2011 10:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: manual merge of the tip tree with the wireless tree
Message-ID: <20110517080939.GD22093@elte.hu>
References: <20110517131417.731cf095.sfr@canb.auug.org.au>
 <20110517070558.GP2573@linux.vnet.ibm.com>
 <20110517172103.a196fbe1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517172103.a196fbe1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Paul,
> 
> On Tue, 17 May 2011 00:05:58 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >
> > One of these is mine in -tip (0744371aeb).  Please let me know what
> > I should be doing about it.
> 
> In this case, I would say absolutely nothing (assuming I did the
> resolution correctly) :-)  If I can figure it out, Linus can as well and
> will do so when these trees hit his in a week or so.

Yeah. The two trees are doing different things, and both commits are within 
their own scopes - so this conflict is a natural (and as it seems, mostly 
contextual) conflict, not a workflow messup.

If such conflicts become too numerous then it would make sense to first push 
rcu_kfree() interface upstream and propagate all the fixlets via the individual 
maintainer trees.

I don't think that's necessary: so far the fallout appears to be limited, but 
Stephen will (or should :-) tell us if a conflicts become too painful for him.

Thanks,

	Ingo
