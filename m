Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1K1ShY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:37:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45019 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1K1ShV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:37:21 -0500
Message-ID: <1322505408.2921.157.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Date: Mon, 28 Nov 2011 19:36:48 +0100
In-Reply-To: <20111128183124.GH2346@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1322484071.2921.115.camel@twins>
	 <20111128171513.GF2346@linux.vnet.ibm.com>
	 <1322504279.2921.154.camel@twins>
	 <20111128183124.GH2346@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 10:31 -0800, Paul E. McKenney wrote:
> Nevertheless, when most people talk to me about explicit reference
> counters, they are thinking in terms of a reference counter within a
> structure protecting that structure.

Right and when I see bulk I think of exactly those but think +=,-=
instead of ++,--.

> > I just hate the name in that it totally obscures the fact that its
> > regular SRCU.
> 
> OK, what names would you suggest? 

How about nothing at all? Simply use the existing SRCU API?
