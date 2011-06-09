Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1FISpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:45:45 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55082 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1FISpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:45:42 -0400
Date: Thu, 9 Jun 2011 11:45:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 14/28] security,rcu: Convert
 call_rcu(whitelist_item_free) to kfree_rcu()
Message-ID: <20110609184534.GJ2285@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <alpine.LRH.2.00.1106091038330.18724@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1106091038330.18724@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 10:39:02AM +1000, James Morris wrote:
> On Wed, 8 Jun 2011, Paul E. McKenney wrote:
> 
> > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > The rcu callback whitelist_item_free() just calls a kfree(),
> > so we use kfree_rcu() instead of the call_rcu(whitelist_item_free).
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: James Morris <jmorris@namei.org>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Acked-by: James Morris <jmorris@namei.org>

Thank you, James!

							Thanx, Paul
