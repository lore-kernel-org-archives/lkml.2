Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab0FPRQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:16:20 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42307 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab0FPRQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LnhAIlIg1g841jeXJ8HOFKDQBwhP2hwzXCsoYuEPqbSNivlO62pAzt9kkBKR5lczf8
         5a6F126FpOGf7MIa8BSejfJCSO3KUuzELa0SfCp2FkQ7c3l/hO1694bQLCK+5xjwPRVG
         Ofh/i8gc+75a9m5i4j1LTf9sFJzRtO8p6l8ow=
Date: Wed, 16 Jun 2010 19:16:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/8] perf: Unindent labels
Message-ID: <20100616171611.GB5530@nowhere>
References: <20100616160027.590430763@chello.nl> <20100616160238.347022826@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616160238.347022826@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:00:31PM +0200, Peter Zijlstra wrote:
> Fixup random annoying style bits
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/perf_event.c |   43 ++++++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -147,7 +147,7 @@ perf_lock_task_context(struct task_struc
>  	struct perf_event_context *ctx;
>  
>  	rcu_read_lock();
> - retry:
> +retry:



The point in having a space before the label starts is that it doesn't
appear as a function boundary in patches.

This avoid patches that look like:

@@ -xxx +yyy @@ out:
-	blah

