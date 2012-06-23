Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab2FWF7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 01:59:48 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56750 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2FWF7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 01:59:47 -0400
Date: Fri, 22 Jun 2012 22:59:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 07/17] key: Remove extraneous parentheses
 from rcu_assign_keypointer()
Message-ID: <20120623055932.GF2516@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340379312-6684-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120622153501.GA6626@linux.vnet.ibm.com>
 <1340379312-6684-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <29983.1340381076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29983.1340381076@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062305-7408-0000-0000-0000062321A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 05:04:36PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This commit removes the extraneous parentheses from rcu_assign_keypointer()
> > so that rcu_assign_pointer() can be wrapped in do-while.
> 
> Should it be wrapped in a do-while itself then?
> 
> And whilst you're at it, could you wrap PAYLOAD in parentheses?

Will do!

							Thanx, Paul

