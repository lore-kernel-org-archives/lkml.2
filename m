Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0C3JMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:12:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:41248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755964Ab0C3JMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:12:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/KNigD/RfKpiIq2awnKYFEptrnMLVkXRaMX7zMBc
	fbVQTdZKX2G/7G
Subject: Re: scheduler bug: process running since 5124095h
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1269939704.5109.513.camel@twins>
References: <4BADD408.8080609@gmail.com>  <4BAF1802.8070002@gmail.com>
	 <1269859960.6844.4.camel@marge.simson.net>
	 <4BB09736.5010009@jp.fujitsu.com>  <4BB1989D.4050809@jp.fujitsu.com>
	 <1269939704.5109.513.camel@twins>
Content-Type: text/plain
Date: Tue, 30 Mar 2010 11:12:04 +0200
Message-Id: <1269940324.19286.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 11:01 +0200, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 15:22 +0900, Hidetoshi Seto wrote:
> > 
> > [kernel/sched_debug.c]
> > void proc_sched_set_task(struct task_struct *p)
> > {
> >  :
> >         p->se.sum_exec_runtime                  = 0;
> >         p->se.prev_sum_exec_runtime             = 0;
> >         p->nvcsw                                = 0;
> >         p->nivcsw                               = 0;
> > } 
> 
> Urgh, that code should really die, bugger that latencytop relies on that
> though. Arjan anything you can do to cure latencytop of this madness?

I killed those 4 fields without _seeming_ to upset it.

	-Mike

