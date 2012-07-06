Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2GFQKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab2GFQJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:09:58 -0400
Date: Fri, 6 Jul 2012 18:07:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] uprobes: write_opcode() cleanups
Message-ID: <20120706160704.GA8499@redhat.com>
References: <20120624145936.GA23269@redhat.com> <20120706105425.GA31587@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706105425.GA31587@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Hello,
> >
> > write_opcode() cleanups resend + new minor fix.
> >
> > Changes:
> >
> > 	- document the new argument in 2/5.
> >
> > 	- drop the buggy 5/5, thanks Anton for your quick nack.
> > 	  Probably I'll return to this later, I have another reason
> > 	  for this change.
> >
> > 	- so this 5/5 is new.
> >
> > Srikar, please add your acks unless you have some objections.
>
> Just wondering what's the review status of patches #1-#4?

I hope Srikar will ack 1-4 soon.

He observed the testing failures, but it turns out this series
is innocent.

I'll send more fixes soon.

> I'll skip #5 based on Oleg's request,

Yes, thanks. I still think 5/5 makes sense, but we need to do
something with uprobe.s:vma_address() first.

Oleg.

