Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab1CYTXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:23:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49720 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1CYTX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:23:28 -0400
Date: Fri, 25 Mar 2011 12:23:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: linux-next: build warning after merge of the rcu tree
Message-ID: <20110325192319.GU2322@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110325160539.659fe452.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325160539.659fe452.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 04:05:39PM +1100, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the rcu tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> kernel/softirq.c:62: warning: excess elements in array initializer
> kernel/softirq.c:62: warning: (near initialization for 'softirq_to_name')
> 
> Introduced by commit 0ac7e739ad17 ("rcu: move TREE_RCU from softirq to
> kthread").

I must confess that it didn't occur to me to check for more than one
array of softirq names, and I have no idea why I didn't see this warning
in my builds.  In any case, I have fixed this and updated -rcu.

I just now found the mention of RCU in the proc.txt documentation file,
and have a fix for that queued as well, and will export to -rcu on the
next round.

							Thanx, Paul
