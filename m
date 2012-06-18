Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2FRMZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:25:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19473 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2FRMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:25:12 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=POXSTHpag7MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=dOCTTjtUIargT7NTa7oA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340022309.25903.69.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.5] ftrace: Make all inline tags also
 include notrace
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <wfg@linux.intel.com>
Date: Mon, 18 Jun 2012 08:25:09 -0400
In-Reply-To: <20120618085626.GA28824@gmail.com>
References: <1339714048.13377.246.camel@gandalf.stny.rr.com>
	 <20120618085626.GA28824@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 10:56 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >     ftrace: Make all inline tags also include notrace
> >     
> >     Commit 5963e317b1 ftrace/x86: Do not change stacks in DEBUG when calling lockdep
> >     prevented lockdep calls from the int3 breakpoint handler from reseting the
> >     stack if a function that was called was in the process of being converted
> >     for tracing and had a breakpoint on it.
> 
> That's now how we refer to commits ...
> 
> >     Commit 45959ee7 ftrace: Do not function trace inlined functions
> >     only touched the 'inline' tags when CONFIG_OPMITIZE_INLINING was enabled.
> 
> neither this :-/
> 
> We tend to write it like this:
> 
>       Commit 45959ee7aa64 ("ftrace: Do not function trace 
>       inlined functions") only touched the 'inline' tags when 
>       CONFIG_OPMITIZE_INLINING was enabled.

This looks like something that should be added to SubmittingPatches.

Want me to rebase with a new changelog?

-- Steve


