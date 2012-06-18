Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2FRI4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:56:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59200 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2FRI4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:56:32 -0400
Date: Mon, 18 Jun 2012 10:56:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <wfg@linux.intel.com>
Subject: Re: [PATCH][GIT PULL][v3.5] ftrace: Make all inline tags also
 include notrace
Message-ID: <20120618085626.GA28824@gmail.com>
References: <1339714048.13377.246.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339714048.13377.246.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

>     ftrace: Make all inline tags also include notrace
>     
>     Commit 5963e317b1 ftrace/x86: Do not change stacks in DEBUG when calling lockdep
>     prevented lockdep calls from the int3 breakpoint handler from reseting the
>     stack if a function that was called was in the process of being converted
>     for tracing and had a breakpoint on it.

That's now how we refer to commits ...

>     Commit 45959ee7 ftrace: Do not function trace inlined functions
>     only touched the 'inline' tags when CONFIG_OPMITIZE_INLINING was enabled.

neither this :-/

We tend to write it like this:

      Commit 45959ee7aa64 ("ftrace: Do not function trace 
      inlined functions") only touched the 'inline' tags when 
      CONFIG_OPMITIZE_INLINING was enabled.

Thanks,

	Ingo
