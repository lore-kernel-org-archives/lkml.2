Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab2JaH0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:26:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2JaH0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:26:07 -0400
Message-ID: <1351668321.4047.39.camel@twins>
Subject: Re: [PATCH tip/core/rcu 0/2] v2 Add callback-free CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        joe.korty@ccur.com
Date: Wed, 31 Oct 2012 08:25:21 +0100
In-Reply-To: <20121031034552.GA1999@linux.vnet.ibm.com>
References: <20121031034552.GA1999@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 20:45 -0700, Paul E. McKenney wrote:
> This commit therefore adds the ability
> for selected CPUs ("rcu_nocbs=" boot parameter) to have their
> callbacks
> offloaded to kthreads, inspired by Joe Korty's and Jim Houston's JRCU.
> If the "rcu_nocb_poll" boot parameter is also specified, these
> kthreads
> will do polling, removing the need for the offloaded CPUs to do
> wakeups. 

How much pain to make that dynamically configurable?
