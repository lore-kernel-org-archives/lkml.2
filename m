Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1FIAk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:40:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:35844 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1FIAk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:40:26 -0400
Date: Thu, 9 Jun 2011 10:39:02 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 14/28] security,rcu: Convert
 call_rcu(whitelist_item_free) to kfree_rcu()
In-Reply-To: <1307561407-13809-14-git-send-email-paulmck@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1106091038330.18724@tundra.namei.org>
References: <20110608192943.GA13211@linux.vnet.ibm.com> <1307561407-13809-14-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Paul E. McKenney wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The rcu callback whitelist_item_free() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(whitelist_item_free).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: James Morris <jmorris@namei.org>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
