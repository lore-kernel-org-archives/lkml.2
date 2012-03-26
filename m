Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2CZA7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 20:59:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:51524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2CZA7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 20:59:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145243550"
Subject: Re: [PATCH 2/2] enable dumpstack() to printk log level
From: "he, bo" <bo.he@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foudation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
In-Reply-To: <20120323122208.GB13920@gmail.com>
References: <1332493027.2359.5.camel@hebo> <1332493269.2359.9.camel@hebo>
	 <20120323122208.GB13920@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 08:59:29 +0800
Message-ID: <1332723569.2359.16.camel@hebo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 13:22 +0100, Ingo Molnar wrote:
> * he, bo <bo.he@intel.com> wrote:
> 
> > --- a/arch/x86/kernel/dumpstack.c
> > +++ b/arch/x86/kernel/dumpstack.c
> > @@ -177,20 +177,29 @@ void show_stack(struct task_struct *task, unsigned long *sp)
> >  }
Ingo,

Thanks for your kind comments. It's the 1st time for me to send patches to LKML.
There are 2 patches. I sent the 1st one to a wrong address. I will resend the 2 patches.

> >  
> >  /*
> > - * The architecture-independent dump_stack generator
> > + * The architecture-independent dump_stack_log_lvl generator
> 
> I guess it wants to say "architecture-dependent"?
Right. I will change it to architecture-dependent.

> 
> > +	show_trace_log_lvl(NULL, NULL, &stack, bp, log_lvl);
> > +}
> > +EXPORT_SYMBOL(dump_stack_log_lvl);
> 
> this should be a _GPL export.
Yes. I will change it.

> 
> > +}
> > +EXPORT_SYMBOL(dump_stack_log_lvl);
Yes. I will change it.


