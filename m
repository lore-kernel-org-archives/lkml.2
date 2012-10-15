Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2JOVmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:42:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57584 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab2JOVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
 <1349998076-15495-2-git-send-email-dhsharp@google.com> <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
From: David Sharp <dhsharp@google.com>
Date: Mon, 15 Oct 2012 14:42:16 -0700
Message-ID: <CAJL_ektJgQayiTPAkxxaT3TZLuUCjo2UsFuhMuxCsp-DFVqjFQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] tracing,x86: Add a TSC trace_clock
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:05 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Oct 12, 2012 at 1:27 AM, David Sharp <dhsharp@google.com> wrote:
>> +#include <asm-generic/trace_clock.h>
>
> Please use the Kbuild infrastructure ("generic-y += ..." in
> arch/*/include/asm/Kbuild)
> instead of adding wrappers around the asm-generic version.

mips apparently recencly got rid of arch/mips/include/asm/Kbuild. What
should I do for mips?

>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
