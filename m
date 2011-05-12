Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1ELMtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:49:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:39117 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1ELMto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:49:44 -0400
From: Richard Weinberger <richard@nod.at>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] [RFC] remove warning and warning_symbol from struct stacktrace_ops
Date: Thu, 12 May 2011 14:48:19 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        oprofile-list@lists.sf.net, oleg@redhat.com, akpm@linux-foundation.org,
        ying.huang@intel.com, ssp@redhat.com, namhyung@gmail.com,
        x86@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        robert.richter@amd.com, Ingo Molnar <mingo@elte.hu>
References: <1304709791-4232-1-git-send-email-richard@nod.at> <20110511223719.GC1846@nowhere>
In-Reply-To: <20110511223719.GC1846@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105121448.19446.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 12 Mai 2011, 00:37:23 schrieb Frederic Weisbecker:
> On Fri, May 06, 2011 at 09:23:11PM +0200, Richard Weinberger wrote:
> > Both warning and warning_symbol are nowhere used.
> > Let's get rid of them.
> 
> I have no clue what it was used for. But fine let's assume
> it's a leftover of some previous removal.
> 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> > 
> >  arch/sh/include/asm/stacktrace.h  |    3 ---
> >  arch/sh/kernel/dumpstack.c        |   15 ---------------
> >  arch/sh/kernel/perf_callchain.c   |   12 ------------
> >  arch/sh/kernel/stacktrace.c       |   13 -------------
> >  arch/sh/oprofile/backtrace.c      |   13 -------------
> 
> Can you please split your patch in two parts: one for sh and
> another for x86?

Sure. Will resend!

Thanks,
//richard
