Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2IERLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:11:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:57798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2IERLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:11:19 -0400
Message-ID: <1346865065.2600.34.camel@twins>
Subject: Re: linux-next: manual merge of the rcu tree with the tip tree
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 05 Sep 2012 19:11:05 +0200
In-Reply-To: <20120905163959.GF3308@linux.vnet.ibm.com>
References: <20120905135947.34ba1c8356cbfe374c6c4ea8@canb.auug.org.au>
	 <20120905163959.GF3308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 09:39 -0700, Paul E. McKenney wrote:
> On Wed, Sep 05, 2012 at 01:59:47PM +1000, Stephen Rothwell wrote:
> > Hi Paul,
> > 
> > Today's linux-next merge of the rcu tree got a conflict in
> > kernel/sched/core.c between commit f319da0c6894 ("sched: Fix load avg vs
> > cpu-hotplug") from the tip tree and commit ead504e5600e ("sched: Fix load
> > avg vs cpu-hotplug") from the rcu tree.
> > 
> > These are 2 slightly different versions of the same patch :-( Same author
> > time, different commit times ...  The rcu tree version contains this
> > extra bit in the commit message:
> > 
> > "    [ paulmck: Move call to calc_load_migration to CPU_DEAD to avoid
> >      miscounting noted by Rakib. ]"
> > 
> > So I used it.  Let me know if this is not correct.
> 
> My guess is that Peter Zijlstra will replace my version at some point,
> at which point I will drop mine.  But from what I can see, the version
> currently  in -tip is the older version, so I will keep mine until
> -tip updates.

Yeah, that was a fail on my part. I'll go sort it after dinner.
