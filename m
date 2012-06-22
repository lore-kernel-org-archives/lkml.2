Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367Ab2FVQHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab2FVQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:07:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1340379312-6684-6-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1340379312-6684-6-git-send-email-paulmck@linux.vnet.ibm.com> <20120622153501.GA6626@linux.vnet.ibm.com> <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 06/17] rcu: Remove return value from RCU_INIT_POINTER()
Date: Fri, 22 Jun 2012 17:06:21 +0100
Message-ID: <30026.1340381181@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The return value from RCU_INIT_POINTER() is not used, and using it
> would be quite ugly, for example:
> 
> 	q = RCU_INIT_POINTER(global_p, p);
> 
> To prevent this sort of ugliness from appearing, this commit wraps
> RCU_INIT_POINTER() in a do-while loop.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: David Howells <dhowells@redhat.com>
