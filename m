Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab1EKWhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:37:31 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58727 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1EKWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H3KGk404hvvGDccGuglsmiULG8gOcwD4LvPNBokpSxkmB+H6rUdmPgDvrprj7KQKkf
         ysZwrUwEGmBvNT4K4OroGhwlMYK+1vk0jzRJhVp/6kDdb50izAtAZdmjrNDA0A4kpN95
         LLi5MWOaYfbvsAmWkI7rZ+mUX/WUE2eQ7Ft+Q=
Date: Thu, 12 May 2011 00:37:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        oprofile-list@lists.sf.net, oleg@redhat.com, akpm@linux-foundation.org,
        ying.huang@intel.com, ssp@redhat.com, namhyung@gmail.com,
        x86@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        robert.richter@amd.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [RFC] remove warning and warning_symbol from struct
 stacktrace_ops
Message-ID: <20110511223719.GC1846@nowhere>
References: <1304709791-4232-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304709791-4232-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 09:23:11PM +0200, Richard Weinberger wrote:
> Both warning and warning_symbol are nowhere used.
> Let's get rid of them.

I have no clue what it was used for. But fine let's assume
it's a leftover of some previous removal.

> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/sh/include/asm/stacktrace.h  |    3 ---
>  arch/sh/kernel/dumpstack.c        |   15 ---------------
>  arch/sh/kernel/perf_callchain.c   |   12 ------------
>  arch/sh/kernel/stacktrace.c       |   13 -------------
>  arch/sh/oprofile/backtrace.c      |   13 -------------

Can you please split your patch in two parts: one for sh and
another for x86?

Thanks.

>  arch/x86/include/asm/stacktrace.h |    3 ---
>  arch/x86/kernel/cpu/perf_event.c  |   13 -------------
>  arch/x86/kernel/dumpstack.c       |   16 ----------------
>  arch/x86/kernel/stacktrace.c      |   13 -------------
>  arch/x86/oprofile/backtrace.c     |   13 -------------
>  10 files changed, 0 insertions(+), 114 deletions(-)
