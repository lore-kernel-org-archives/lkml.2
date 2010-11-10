Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0KJNpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:45:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0KJNpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:45:02 -0500
Date: Wed, 10 Nov 2010 14:44:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing,mm - add kernel pagefault tracepoint for x86
 & x86_64
Message-ID: <20101110134436.GD1949@jolsa.brq.redhat.com>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
 <1289390172-9730-2-git-send-email-jolsa@redhat.com>
 <20101110132954.GA2101@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110132954.GA2101@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:29:54AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 10, 2010 at 12:56:11PM +0100, Jiri Olsa wrote:
> > +	TP_printk("task=%lx, address=%lx, regs=%lx",
> > +		(unsigned long)__entry->task, (unsigned long)__entry->address,
> > +			__entry->regs)
> 
> How exactly do you use the information in this trace point?  Especially
> the undecoded pt_regs doesn't seem very useful to me at all.

agreed, the registers pointer are not very useful in the trace file output,
and could be taken away.. just wanted to be complete I guess

but I believe they are useful when you register the mm_kernel_pagefault
tracepoint and process the information by yourself

wbr,
jirka
