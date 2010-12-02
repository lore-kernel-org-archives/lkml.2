Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab0LBXe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:34:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166Ab0LBXe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:34:28 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=0jA3ngOw4AsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ayQCLtDfg3Zue7cRFYQA:9 a=ZNF5ZBpe4N_mLL6IpUnO2faQ_XEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/2] [PATCH 1/2] tracing: Add
 TRACE_EVENT_CONDITIONAL()
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <4CF824A8.2070807@caviumnetworks.com>
References: <20101202223654.596106888@goodmis.org>
	 <20101202224814.667536793@goodmis.org>
	 <4CF824A8.2070807@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Dec 2010 18:34:26 -0500
Message-ID: <1291332866.3228.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 14:58 -0800, David Daney wrote:
> On 12/02/2010 02:36 PM, Steven Rostedt wrote:

> > For example, for the tracepoint sched_wakeup, it is useless to
> > trace an wakeup event where the caller never actually work
> > anything up (success = 0). So adding:
>                        ^^^
>                     s/=/==/
> 
> As much as I hate to be a pedant, I would suggest changing this change 
> log for the sake of clarity.

Eek! Yeah I'll fix that, along with s/work anything/woke anything/.

Thanks,

-- Steve


