Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0KEPHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:07:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34117 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab0KEPG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:06:58 -0400
Date: Fri, 5 Nov 2010 08:06:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: dyntick-hpc and RCU
Message-ID: <20101105150648.GB2850@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105052740.GB6698@nowhere>
 <AANLkTi=RiYTsYfh9sBLBzKeZWJp8HOCP+RnOTQA-MFHL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=RiYTsYfh9sBLBzKeZWJp8HOCP+RnOTQA-MFHL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 06:38:17AM +0100, Frederic Weisbecker wrote:
> 2010/11/5 Frederic Weisbecker <fweisbec@gmail.com>:
> > For now #3 seems to me more viable (with one of the adds I proposed).
> 
> Doh, but I forgot it's not preemptable! So #2 looks then more viable.
> Unless we can tweak #3 into getting it preemptable.

There are ways of getting preemptiblity working.  This might not be
all that big a modification to TREE_PREEMPT_RCU, now that I think
of it.

							Thanx, Paul
