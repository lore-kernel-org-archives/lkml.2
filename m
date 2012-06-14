Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2FNW6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:58:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2FNW6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:58:47 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=G0s97Kyuy1EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D19gQVrFAAAA:8 a=3zL9KP1dC-dLpBzUJXkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339714725.13377.252.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 14 Jun 2012 18:58:45 -0400
In-Reply-To: <alpine.LFD.2.02.1206142345100.3086@ionos>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 00:47 +0200, Thomas Gleixner wrote:
> I lost another day of waiting for a complex bug to trigger and turn
> off tracing, which did not happen due to:
> 
>  commit 499e54705(tracing/ring-buffer: Only have tracing_on disable
>  tracing buffers)

I submitted this last week: https://lkml.org/lkml/2012/6/6/701

I forgot to Cc you.

Sorry,

-- Steve



