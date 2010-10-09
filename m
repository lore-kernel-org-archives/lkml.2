Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab0JID7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 23:59:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0JID7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 23:59:51 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=Zt58hVK3vDgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Qxba-69QD0w2awyH-C8A:9 a=-CjriZLV8BxyQVRgT9r4uWe2MPQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/9] [GIT PULL] tracing: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101008084541.GA23742@elte.hu>
References: <20101006033445.465428951@goodmis.org>
	 <20101008081655.GC13754@elte.hu>  <20101008084541.GA23742@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 08 Oct 2010 23:59:47 -0400
Message-ID: <1286596787.23994.1285.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 10:45 +0200, Ingo Molnar wrote:
> hm, i'm getting:
> 
> arch/x86/kernel/alternative.c: Assembler messages:
> arch/x86/kernel/alternative.c:674: Error: symbol `ftrace_test_jmp' is already defined
> arch/x86/kernel/alternative.c:678: Error: symbol `ftrace_test_p6nop' is already defined
> arch/x86/kernel/alternative.c:680: Error: symbol `ftrace_test_nop5' is already defined
> 
> Config attached.

I'll see if I can get to this early next week. I'll be leaving to NYC on
Monday for the End Users Summit. I'll try to look at this while there.

Thanks!

-- Steve


