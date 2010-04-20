Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0DTKMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:12:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab0DTKMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:12:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1271355219-20714-7-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1271355219-20714-7-git-send-email-paulmck@linux.vnet.ibm.com> <20100415181255.GA19588@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 07/16] rcu: shrink rcutiny by making synchronize_rcu_bh() be inline
Date: Tue, 20 Apr 2010 11:11:06 +0100
Message-ID: <31621.1271758266@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Does it make sense for synchronize_sched() to be inline too?  Since that's
just a wrapper around cond_resched(), which is normally just a wrapper around
_cond_resched().

Otherwise:

Acked-by: David Howells <dhowells@redhat.com>
