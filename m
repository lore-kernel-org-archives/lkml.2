Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab2CKHwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 03:52:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58908 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2CKHwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 03:52:20 -0400
Date: Sun, 11 Mar 2012 10:52:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
Message-ID: <20120311075212.GA3794@p183.telecom.by>
References: <20120309074202.GA28609@www.outflux.net>
 <20120309092845.GA10281@elte.hu>
 <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 08:30:49AM -0800, Kees Cook wrote:
> >> +enum {
> >> +     INTR_DIV_BY_ZERO = 0,   /*  0 */
> >> +     INTR_DEBUG,             /*  1 */
> >> +     INTR_NMI,               /*  2 */
> >> +     INTR_BREAKPOINT,        /*  3 */
> >> +     INTR_OVERFLOW,          /*  4 */
> >> +     INTR_BOUNDS_CHECK,      /*  5 */
> >> +     INTR_INVALID_OP,        /*  6 */
> >> +     INTR_NO_DEV,            /*  7 */
> >> +     INTR_DBL_FAULT,         /*  8 */
> >> +     INTR_SEG_OVERRUN,       /*  9 */
> >> +     INTR_INVALID_TSS,       /* 10 */
> >> +     INTR_NO_SEG,            /* 11 */
> >> +     INTR_STACK_FAULT,       /* 12 */
> >> +     INTR_GPF,               /* 13 */
> >> +     INTR_PAGE_FAULT,        /* 14 */
> >> +     INTR_SPURIOUS,          /* 15 */
> >> +     INTR_COPROCESSOR,       /* 16 */
> >> +     INTR_ALIGNMENT,         /* 17 */
> >> +     INTR_MCE,               /* 18 */
> >> +     INTR_SIMD_COPROCESSOR,  /* 19 */
> >> +     INTR_IRET = 32,         /* 32 */
> >> +};

This should be written like INTR_DEBUG=1 etc
