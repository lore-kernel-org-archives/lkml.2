Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0IBObO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:31:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0IBObN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:31:13 -0400
Subject: Re: [RFD][checkpatch] warnings on space in front of labels
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1283437098.2356.135.camel@gandalf.stny.rr.com>
References: <1283437098.2356.135.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Sep 2010 16:31:07 +0200
Message-ID: <1283437867.2012.213.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 10:18 -0400, Steven Rostedt wrote:
> 
> There's a new warning that I've seen lately. It is about complaining
> about spaces starting on a new line.
> 
> WARNING: please, no space for starting a line, 
>                                 excluding comments
> #90: FILE: trace-read.c:612:
> + again:$
> 
> 
> Comments are currently the exception, but I would also like to add
> labels too. 

I really hate that /^ label/ stuff and I'm removing them everywhere I
can.


> I really prefer the space in front of the label. In fact, I think it
> should be the default.
> 
> But could we at least remove the warning for spaces in front of labels?

No, kill those spaces with prejudice.

> What do others think?

I'd prefer to run a script over the kernel and remove all those silly spaces.
