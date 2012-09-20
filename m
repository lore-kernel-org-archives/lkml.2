Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2ITJZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:25:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33469 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2ITJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:25:46 -0400
Date: Thu, 20 Sep 2012 11:25:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, kprobes: Hide skip_singlestep forward declaration
 properly
Message-ID: <20120920092540.GB3611@gmail.com>
References: <1348062414-6578-1-git-send-email-bp@amd64.org>
 <505ADB6B.3070706@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <505ADB6B.3070706@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2012/09/19 22:46), Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > I get
> > 
> > arch/x86/kernel/kprobes.c:544:23: warning: ‘skip_singlestep’ declared ‘static’ but never defined [-Wunused-function]
> > 
> > on tip/auto-latest.
> > 
> > Hide the forward declaration in the KPROBES_CAN_USE_FTRACE as it
> > is done in its callsites.
> 
> Thank you for reporting and fixing :)

Why is a forward declation needed, why isn't the function in the 
proper spot in the file to begin with?

Thanks,

	Ingo
