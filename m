Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2JXKgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:36:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61071 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab2JXKgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:36:04 -0400
Date: Wed, 24 Oct 2012 12:35:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] x86: Provide a comment in uapi/asm/hw_breakpoint.h
Message-ID: <20121024103559.GB10691@gmail.com>
References: <20121022120558.14413.78980.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022120558.14413.78980.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Provide a comment in the empty uapi/asm/hw_breakpoint.h to make sure that the
> patch program doesn't delete it.
> 
> However, should some part of asm/hw_breakpoint.h actually be exported here,
> or, possibly, should the entire uapi file be removed?  In v3.6, though the
> file was marked for export to userspace, it had nothing outside of __KERNEL__.
> 
> This needs to be applied on top of the x86 UAPI disintegration patch.

Just wondering, have the tools/perf/ issues been solved in your 
tree, are the x86 UAPI disintegration changes pullable?

Thanks,

	Ingo
