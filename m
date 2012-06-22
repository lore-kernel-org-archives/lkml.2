Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2FVQFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:05:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab2FVQFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:05:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1340379312-6684-7-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1340379312-6684-7-git-send-email-paulmck@linux.vnet.ibm.com> <20120622153501.GA6626@linux.vnet.ibm.com> <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 07/17] key: Remove extraneous parentheses from rcu_assign_keypointer()
Date: Fri, 22 Jun 2012 17:04:36 +0100
Message-ID: <29983.1340381076@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This commit removes the extraneous parentheses from rcu_assign_keypointer()
> so that rcu_assign_pointer() can be wrapped in do-while.

Should it be wrapped in a do-while itself then?

And whilst you're at it, could you wrap PAYLOAD in parentheses?

Thanks,
David
