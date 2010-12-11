Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0LKAHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:07:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab0LKAHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:07:33 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=jAmd2lEfFiEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=G2pEFJyoj6u9pRdmD5IA:9 a=EouEY517HSJCprInfmYA:7 a=6u95JcEF_nyXq4VkYhqpJrPRuUcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 04/10] sched: Change pick_next_task_rt from
 unlikely to likely
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4CFD59CD0200005A00077F6C@novprvoes0310.provo.novell.com>
References: <20101207015834.196176991@goodmis.org>
	 <20101207021329.185936860@goodmis.org>
	 <4CFD59CD0200005A00077F6C@novprvoes0310.provo.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 10 Dec 2010 19:07:29 -0500
Message-ID: <1292026049.5015.1539.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 19:46 -0700, Gregory Haskins wrote:

> My feeling is that generally speaking, if the branch is workload dependent, we should probably not annotate it at all and let the CPUs branch-predictor do its thing.  I guess what I am not 100% clear on is how these annotations affect the BPU.  I.e. is it a static decision point or can the BPU still "learn" if the annotation is particularly wrong for a given workload?  For the former, I think we should just remove this particular annotation (and there are others that need review).  For the latter, this is obviously the right annotation we should be using in this particular case.
> 

You need to get a better email client ;-)

OK, if I just remove the likely() do you Ack it?

-- Steve


