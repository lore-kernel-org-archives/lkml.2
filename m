Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab1KYPXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 10:23:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1KYPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 10:23:39 -0500
Subject: Re: [PATCH v7 3.2-rc2 12/30] uprobes: Handle breakpoint and
 Singlestep
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
In-Reply-To: <20111118110903.10512.88532.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110903.10512.88532.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 16:24:22 +0100
Message-ID: <1322234662.2535.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:39 +0530, Srikar Dronamraju wrote:

> +       consumer = uprobe->consumers;
> +       for (consumer = uprobe->consumers; consumer;
> +                                       consumer = consumer->next) { 

that first expression seems redundant..

