Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2ITLFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:05:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45102 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2ITLFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:05:20 -0400
Date: Thu, 20 Sep 2012 13:05:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, kprobes: Hide skip_singlestep forward declaration
 properly
Message-ID: <20120920110515.GA5996@gmail.com>
References: <1348062414-6578-1-git-send-email-bp@amd64.org>
 <505ADB6B.3070706@hitachi.com>
 <20120920092540.GB3611@gmail.com>
 <505AE3B5.6080401@hitachi.com>
 <20120920094017.GA4918@gmail.com>
 <20120920103315.GC15391@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920103315.GC15391@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Thu, Sep 20, 2012 at 11:40:17AM +0200, Ingo Molnar wrote:
>
> > Could be moved into a separate file as well - we could have 
> > arch/x86/kprobes/, with core.c, opt.c, ftrace.c and common.h 
> > in it - possibly more in the future.
> 
> So, I'm guessing I should move only the function now and let 
> Masami do the proper splitup later, correct?

Yeah, I guess.

Thanks,

	Ingo
