Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab0DHTEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:04:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab0DHTEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:04:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100408164615.GA4836@linux.vnet.ibm.com>
References: <20100408164615.GA4836@linux.vnet.ibm.com> <20100407171342.GF2481@linux.vnet.ibm.com> <20100407162620.GA11543@linux.vnet.ibm.com> <27310.1270659627@redhat.com> <27837.1270660848@redhat.com> <20100407230009.GK2481@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/urgent] rcu: add rcu_access_pointer and rcu_dereference_protected
Date: Thu, 08 Apr 2010 20:04:07 +0100
Message-ID: <12448.1270753447@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> And all of the examples I could come up with that had c!=1 were contorted,
> even by my standards.  So you were right, and I will drop the "c" on my
> next set of patches.

:-)

When it's done, I'll rebuild my keys and NFS patches on top of it.

David
