Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2DPLkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:40:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43359 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2DPLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:40:11 -0400
Date: Mon, 16 Apr 2012 17:01:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120416113124.GA25464@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120405222024.GA19154@redhat.com>
 <20120414111637.GB24688@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120414111637.GB24688@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041611-5518-0000-0000-000003B04D45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@kernel.org> [2012-04-14 13:16:37]:

> 
> * Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Hello.
> > 
> > Not for inclusion yet, only for the early review.
> 
> Srikar, any objection to these? They look like fine changes to 
> me in principle, making uprobes less of an overhead to other 
> kernel subsystems.
> 

I dont have any objections to Oleg's changes. However as Oleg has said,
they are currently untested. Once the tracing and perf bits are in -tip,
I will add these bits and test them and let you know.

Given that I have tested the current bits in -tip several times, I think
it might be worthwhile to keep these changes on hold till the current
uprobe bits in -tip go upstream. 

Oleg: Would this be acceptable?

-- 
Thanks and Regards
Srikar

