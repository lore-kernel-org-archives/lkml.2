Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2CJIea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 03:34:30 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39719 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2CJIe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 03:34:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120309221302.GA17158@elte.hu>
References: <20120309074202.GA28609@www.outflux.net>
	<20120309092845.GA10281@elte.hu>
	<CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
	<4F5A448D.70605@zytor.com>
	<CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
	<20120309182829.GA13745@aftab>
	<1331319124.25686.580.camel@gandalf.stny.rr.com>
	<4F5A63B3.1040509@zytor.com>
	<20120309221302.GA17158@elte.hu>
Date: Sat, 10 Mar 2012 10:34:27 +0200
X-Google-Sender-Auth: Kid24SSqvBiYV9XERn9pXMjIujs
Message-ID: <CAOJsxLF+hdk2Lk3AhsOR1KiCc6xfWZUpzCvJe4sgGO53abkhDQ@mail.gmail.com>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Borislav Petkov <bp@amd64.org>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 10, 2012 at 12:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> On 03/09/2012 10:52 AM, Steven Rostedt wrote:
>> > I agree too, except where does "XCP" come from? Is it short for
>> > "exception"?
>>
>> Yes, short for "exception".  I hate to admit it, but it comes from the
>> constants we used in the Transmeta microcode ;)
>
> Hm, were I to see 'X86_XCP_MC' for the first time I'd have no
> idea what it means. Really, lets not use random new
> abbreviations, lets use well-known patterns.
>
> Make it X86_TRAP_XX, it's both short and correct?

Yeah, my thoughts exactly. I don't think I have ever seen "XCP" before
so it really feels like an obscure new TLA to me.

                        Pekka
