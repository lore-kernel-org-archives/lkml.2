Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab0GPDCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:02:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53636 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0GPDCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uDFqY9aUMFGm69yG4wlZwJok1fbXbwcfA4aDsIW6XOM7s1qo1/x3+qHNgGbMVC4mmH
         VotLzGrbvYFvpdU3jNKGGjEsRhuhnehNxWRlf0Dr9qW/f6Dr64mRLM/7uoeiMPFssJ7O
         +MBY5p118+p2oTTUjjp31iIBWjkU4prT3rprg=
Date: Fri, 16 Jul 2010 05:02:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 2/2] tracing: Remove special traces
Message-ID: <20100716030214.GB6417@nowhere>
References: <1279237003-31354-1-git-send-regression-fweisbec@gmail.com> <1279237003-31354-3-git-send-regression-fweisbec@gmail.com> <4C3FAD44.1050900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3FAD44.1050900@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 08:52:20AM +0800, Li Zefan wrote:
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 2114b4c..2f8619b 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -22,7 +22,6 @@ enum trace_type {
> >  	TRACE_STACK,
> >  	TRACE_PRINT,
> >  	TRACE_BPRINT,
> > -	TRACE_SPECIAL,
> >  	TRACE_MMIO_RW,
> >  	TRACE_MMIO_MAP,
> >  	TRACE_BRANCH,
> > @@ -332,11 +331,6 @@ void tracing_sched_wakeup_trace(struct trace_array *tr,
> >  				struct task_struct *wakee,
> >  				struct task_struct *cur,
> >  				unsigned long flags, int pc);
> > -void trace_special(struct trace_array *tr,
> > -		   struct trace_array_cpu *data,
> > -		   unsigned long arg1,
> > -		   unsigned long arg2,
> > -		   unsigned long arg3, int pc);
> >  void trace_function(struct trace_array *tr,
> >  		    unsigned long ip,
> >  		    unsigned long parent_ip,
> 
> You forgot to delete this:
> 
>                 IF_ASSIGN(var, ent, struct special_entry, 0);           \


Oops, right, I forgot that. And I forgot to Cc you as well, sorry.

Will fix, thanks.

