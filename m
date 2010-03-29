Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0C2JMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:12:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:49167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab0C2JLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:11:37 -0400
Subject: Re: [RFC patch] extable and module add object is static
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
In-Reply-To: <4BB004ED.5060106@cn.fujitsu.com>
References: <20100327153233.993367557@efficios.com>
	 <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal>
	 <20100327232024.GB4685@Krystal> <20100327234314.GL2343@linux.vnet.ibm.com>
	 <20100328000234.GA4924@Krystal>  <4BB004ED.5060106@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 10:53:34 +0200
Message-ID: <1269852814.12097.167.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 09:39 +0800, Lai Jiangshan wrote:
> Mathieu Desnoyers wrote:
> > +static int core_object_is_static(void *obj)
> > +{
> [...]
> > +	if (addr >= (unsigned long)__per_cpu_start &&
> > +	    addr <= (unsigned long)__per_cpu_end)
> > +		return 1;
> 
> This may only correct for UP.
> You may need arch-special codes for SMP.
> 

Tejun has patches for this.

