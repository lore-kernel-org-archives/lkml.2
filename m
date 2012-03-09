Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab2CISVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:21:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44896 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2CISVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:21:52 -0500
MIME-Version: 1.0
In-Reply-To: <4F5A448D.70605@zytor.com>
References: <20120309074202.GA28609@www.outflux.net>
	<20120309092845.GA10281@elte.hu>
	<CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
	<4F5A448D.70605@zytor.com>
Date: Fri, 9 Mar 2012 10:21:52 -0800
X-Google-Sender-Auth: p0f9r35ehRQmx2O-jzLheSEZqY0
Message-ID: <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 9:57 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/09/2012 08:30 AM, Kees Cook wrote:
>> On Fri, Mar 9, 2012 at 1:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Kees Cook <keescook@chromium.org> wrote:
>>>
>>>> The traps are referred to by their numbers and it can be difficult to
>>>> understand them while reading the code without context. This patch adds
>>>> enumeration of the trap numbers and replaces the numbers with the correct
>>>> enum for x86.
>>>>
>
> I have to admit personally to prefer something like X86_XCP_XX where XX
> is the two-letter code that the Intel documentation uses for that trap,
> i.e. #GP, #BR, #MC and so on.

We need a single person to decide on this bike shed color. :) If the
list of enum names can be agreed on, I'll be happy to do the
search/replace for it.

-Kees

-- 
Kees Cook
ChromeOS Security
