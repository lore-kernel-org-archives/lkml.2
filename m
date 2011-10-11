Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1JKLOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 07:14:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1JKLOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 07:14:14 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=bP4z-tGWBEUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=3azte1_gMcx9JtuuQZgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 00/20] [GIT PULL][v3.2] tracing: queued updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 11 Oct 2011 07:14:10 -0400
In-Reply-To: <20111011081511.GA4523@elte.hu>
References: <20111010133852.829771373@goodmis.org>
	 <1318254776.7904.87.camel@gandalf.stny.rr.com>
	 <20111011055119.GB32616@elte.hu> <20111011081511.GA4523@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318331652.7904.151.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 10:15 +0200, Ingo Molnar wrote:

> but it has not been build tested with the function tracer disabled:
> 
>  kernel/trace/trace.h:588:1: error: multiple storage classes in declaration specifiers

Hmm, I did run randconfig on it a couple of times. But as it is a
randconfig, it must have enabled function tracer each time :-/

I'll need to update my tests with some default configs to try. Including
allyes, mod and allno, and with and without function tracing enabled.

Will fix.

Thanks,

-- Steve




