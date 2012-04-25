Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab2DYLKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:10:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab2DYLKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:10:30 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=9oLMtTzusXUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=hD80L64hAAAA:8 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=UnoOuXimfdPuiC4A0coA:9 a=PUjeQqilurYA:10 a=v3rLFGiuRE8A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335352227.28106.152.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Prevent wasting time evaluating parameters in
 trace_preempt_on/off
From: Steven Rostedt <rostedt@goodmis.org>
To: Minho Ban <mhban@samsung.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Date: Wed, 25 Apr 2012 07:10:27 -0400
In-Reply-To: <4F978CAC.6060408@samsung.com>
References: <4F978CAC.6060408@samsung.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 14:33 +0900, Minho Ban wrote:
> This fixes spending time for evaluating parameters in trace_preempt_on/off when
> the tracer config is off.
> 
> The patch mainly inspired by Steven Rostedt, thanks Steven.
> 
> Signed-off-by: Minho Ban <mhban@samsung.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


