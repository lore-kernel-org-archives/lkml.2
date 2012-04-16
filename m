Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2DPOsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab2DPOsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:48:15 -0400
Date: Mon, 16 Apr 2012 16:41:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20120416144116.GA6745@redhat.com>
References: <20120405222024.GA19154@redhat.com> <20120414111637.GB24688@gmail.com> <20120416113124.GA25464@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416113124.GA25464@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Srikar Dronamraju wrote:
>
> Given that I have tested the current bits in -tip several times, I think
> it might be worthwhile to keep these changes on hold till the current
> uprobe bits in -tip go upstream.
>
> Oleg: Would this be acceptable?

Yes, yes, agreed.

Oleg.

