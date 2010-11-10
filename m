Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0KJNaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:30:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab0KJNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:30:13 -0500
Date: Wed, 10 Nov 2010 08:29:54 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing,mm - add kernel pagefault tracepoint for x86
 & x86_64
Message-ID: <20101110132954.GA2101@infradead.org>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
 <1289390172-9730-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289390172-9730-2-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:56:11PM +0100, Jiri Olsa wrote:
> +	TP_printk("task=%lx, address=%lx, regs=%lx",
> +		(unsigned long)__entry->task, (unsigned long)__entry->address,
> +			__entry->regs)

How exactly do you use the information in this trace point?  Especially
the undecoded pt_regs doesn't seem very useful to me at all.

