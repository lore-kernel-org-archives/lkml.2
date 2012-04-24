Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2DXSSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:18:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab2DXSSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:18:07 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=eegaJL_oNbcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=jiOWup55tWicP73T7IEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335291484.28106.143.camel@gandalf.stny.rr.com>
Subject: Re: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Minho Ban <mhban@samsung.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Turner <pjt@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Date: Tue, 24 Apr 2012 14:18:04 -0400
In-Reply-To: <1335272025.28150.193.camel@twins>
References: <4F969E53.9080307@samsung.com>
	 <1335272025.28150.193.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 14:53 +0200, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 21:36 +0900, Minho Ban wrote:
> > trace_preempt_on/off looks empty if PREEMPT_TRACER is off. But actually it is
> > spending time to find out get_parent_ip(even CALLER_ADDR for some ARCH) which is
> > in argument. This seems not fair for those who expect to do nothing but increase
> > or decrease count.
> 
> You can do the same by making them CPP macros and adding a comment as to
> why they're macros instead of inlines..

I should read the thread before answering. I just repeated basically
exactly what you said ;-)

-- Steve



