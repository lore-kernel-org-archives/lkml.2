Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2LNBRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:17:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9055 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2LNBRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:17:13 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YXxC6ppya9MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jeKsYFhGskIA:10 a=VwQbUJbxAAAA:8 a=o2YJhybyzS7DZUXLfAUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355447831.17101.391.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: Some more updates
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 13 Dec 2012 20:17:11 -0500
In-Reply-To: <20121129012340.602023062@goodmis.org>
References: <20121129012340.602023062@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 20:23 -0500, Steven Rostedt wrote:
> Ingo,
> 
> This is based off of my last pull request on tip/perf/core.
> 
> Please pull the latest tip/perf/core-2 tree, which can be found at:

Ping?

This has been in linux-next for a few weeks too. It's all ready to go in
this merge window.

-- Steve

> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core-2
> 
> Head SHA1: bf3071f5a054db9e5bab873355d27a7330ce5187
> 
> 
> Anton Vorontsov (1):
>       tracing: Remove unneeded checks from the stack tracer
> 
> Dave Jones (1):
>       tracing: Remove unnecessary WARN_ONCE's from tracing_buffers_splice_read
> 
> Hiraku Toyooka (1):
>       tracing: Add a resize function to make one buffer equivalent to another buffer
> 
> ----
>  kernel/trace/trace.c       |   60 +++++++++++++++++++++++---------------------
>  kernel/trace/trace_stack.c |    4 ---
>  2 files changed, 31 insertions(+), 33 deletions(-)


