Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1DPTTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 15:19:17 -0400
Received: from linux-sh.org ([111.68.239.195]:53957 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab1DPTTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 15:19:07 -0400
Date: Sun, 17 Apr 2011 04:17:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] sh: convert to asm-generic ptrace.h
Message-ID: <20110416191757.GA11609@linux-sh.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-5-git-send-email-vapier@gentoo.org> <4DA70319.8000902@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA70319.8000902@mvista.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 06:22:17PM +0400, Sergei Shtylyov wrote:
> Mike Frysinger wrote:
> 
> >Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >---
> > arch/sh/include/asm/ptrace.h |    6 ++++--
> > 1 files changed, 4 insertions(+), 2 deletions(-)
> 
> >diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
> >index b219a08..3f2a6e7 100644
> >--- a/arch/sh/include/asm/ptrace.h
> >+++ b/arch/sh/include/asm/ptrace.h
> [...]
> >@@ -137,6 +136,9 @@ static inline unsigned long profile_pc(struct pt_regs 
> >*regs)
> > 
> > 	return pc;
> > }
> >+#define profile_pc profile_pc
> 
>    Same question about preprocessor...
> 
Same response.

There are many places in the kernel where this convention is used, and
for a good reason. Grep harder.
