Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2ITKdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:33:21 -0400
Received: from mail.x86-64.org ([217.9.48.20]:42304 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2ITKdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:33:20 -0400
Date: Thu, 20 Sep 2012 12:33:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, kprobes: Hide skip_singlestep forward declaration
 properly
Message-ID: <20120920103315.GC15391@aftab.osrc.amd.com>
References: <1348062414-6578-1-git-send-email-bp@amd64.org>
 <505ADB6B.3070706@hitachi.com>
 <20120920092540.GB3611@gmail.com>
 <505AE3B5.6080401@hitachi.com>
 <20120920094017.GA4918@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920094017.GA4918@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 11:40:17AM +0200, Ingo Molnar wrote:
> Could be moved into a separate file as well - we could have
> arch/x86/kprobes/, with core.c, opt.c, ftrace.c and common.h in it -
> possibly more in the future.

So, I'm guessing I should move only the function now and let Masami do
the proper splitup later, correct?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
