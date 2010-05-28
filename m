Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0E1Acm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:32:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56787 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0E1Acl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:32:41 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=mI6YO6ZdSLUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=znfbx945Ue6_QidDlDwA:9 a=BKEsv_I8vi-e5kScjTR2CBB6cdYA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [GIT PULL, v2] perf changes
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org>
References: <20100524192531.GA15614@elte.hu> <20100525002221.GA30395@drongo>
	 <20100525135200.GA21462@elte.hu>
	 <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 27 May 2010 20:32:37 -0400
Message-ID: <1275006757.22648.567.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 15:34 -0700, Linus Torvalds wrote:

> The actual kernel still grew:
> 
>  32 files changed, 1327 insertions(+), 964 deletions(-)

Well, if it's any consolation, that patch pull did include my 100K
reduction in trace events.

-- Steve


