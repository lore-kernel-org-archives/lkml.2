Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1LSOYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:24:18 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:53538 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab1LSOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:24:15 -0500
Date: Mon, 19 Dec 2011 15:24:09 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Glauber Costa <glommer@parallels.com>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
Message-ID: <20111219152409.3a2c213e@de.ibm.com>
In-Reply-To: <20111219112547.GA32375@elte.hu>
References: <20111219154010.c2044c038a6174dd8fb6f477@canb.auug.org.au>
	<20111219080813.GB30432@elte.hu>
	<20111219101134.3c2c0db5@de.ibm.com>
	<20111219103513.GA17928@elte.hu>
	<20111219112547.GA32375@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 11121914-6892-0000-0000-0000008163EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 12:25:47 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > All of it including "[S390] cputime: add sparse checking and 
> > > cleanup" or just the fix for uptime ?
> > 
> > I suspect we can take it all if it's all scheduling/time 
> > related, and add new patches to sched/core to keep it all 
> > concentrated in a single tree?
> 
> Btw., i'd suggest to keep your commits as-is and merge 
> tip:sched/core into your tree - and send the result to me so 
> that we can make that the new sched/core.
> 
> That way your commits are preserved and the conflicts are 
> resolved.

Just did that and pushed out the result on 

 git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git cputime-tip

Pulling either the original tip sched/core branch or the cputime-tip branch
to an up-to-date repository fails by the way, it gives a conflict in
kernel/sched/fair.c.
And then there is the thing with cpustat being u64. It really should be
cputime64_t. How do you want that resolved, I assume an additional patch
on top?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

