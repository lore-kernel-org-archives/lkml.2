Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0EFSgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:36:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:28317 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0EFSgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jGSQZ5m+3cyeLcnyXE1mVVT7kTaZlV+33NwGhsjxC6Fo8J9o4tKZa8qW651B33IOGM
         uVqc3LRWqggpjyuBHjK8MmaYgoTxuUa1N/BPu2LKfyn5tM4ij4S52rAlzZXgih1wbOgm
         ANBtIgdnHlMX2EKql96xnOUkCtIl++lHXaWKc=
Date: Thu, 6 May 2010 22:36:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
	from preemption
Message-ID: <20100506183627.GE5583@lenovo>
References: <20100505165731.GA6320@nowhere> <20100505174234.GH5686@lenovo> <20100506064453.GI1172@elte.hu> <w2vaa79d98a1005060039ua7dd1b0t952fcd8662d4d759@mail.gmail.com> <20100506074231.GA8625@elte.hu> <n2maa79d98a1005060045ke0f87f4aw8b86da0440a019b3@mail.gmail.com> <1273153525.22438.39.camel@gandalf.stny.rr.com> <20100506144854.GB5583@lenovo> <20100506152646.GC5583@lenovo> <1273170753.22438.45.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273170753.22438.45.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 02:32:33PM -0400, Steven Rostedt wrote:
[...]
> > 
> > Steve, while I'm diving through call graph could you give this
> > patch a shot? If preemtion happens -- it'll trigger it fast.
> 
> This one works too.
> 
> Tested-by: Steven Rostedt <rostedt@goodmis.org>
> 
> -- Steve
> 

Thanks a huge, Steven! I'll tinkle a bit more with p4 pmu
and will send a series of patches with this one included.

	-- Cyrill
