Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2ITJk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:40:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61441 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2ITJkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:40:22 -0400
Date: Thu, 20 Sep 2012 11:40:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, kprobes: Hide skip_singlestep forward declaration
 properly
Message-ID: <20120920094017.GA4918@gmail.com>
References: <1348062414-6578-1-git-send-email-bp@amd64.org>
 <505ADB6B.3070706@hitachi.com>
 <20120920092540.GB3611@gmail.com>
 <505AE3B5.6080401@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <505AE3B5.6080401@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2012/09/20 18:25), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >> (2012/09/19 22:46), Borislav Petkov wrote:
> >>> From: Borislav Petkov <borislav.petkov@amd.com>
> >>>
> >>> I get
> >>>
> >>> arch/x86/kernel/kprobes.c:544:23: warning: ‘skip_singlestep’ declared ‘static’ but never defined [-Wunused-function]
> >>>
> >>> on tip/auto-latest.
> >>>
> >>> Hide the forward declaration in the KPROBES_CAN_USE_FTRACE as it
> >>> is done in its callsites.
> >>
> >> Thank you for reporting and fixing :)
> > 
> > Why is a forward declation needed, why isn't the function in the 
> > proper spot in the file to begin with?
> 
> There is no reason, ftrace-related things can also be moved on top.
> Borislav, could you move it?

Could be moved into a separate file as well - we could have 
arch/x86/kprobes/, with core.c, opt.c, ftrace.c and common.h in 
it - possibly more in the future.

Thanks,

	Ingo
