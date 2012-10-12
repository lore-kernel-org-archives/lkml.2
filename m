Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2JLFFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:05:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60773 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2JLFFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:05:52 -0400
MIME-Version: 1.0
In-Reply-To: <1349998076-15495-2-git-send-email-dhsharp@google.com>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
	<1349998076-15495-2-git-send-email-dhsharp@google.com>
Date: Fri, 12 Oct 2012 07:05:51 +0200
X-Google-Sender-Auth: kCEWS_6SfupxG9rrb8n7iLCUX_Y
Message-ID: <CAMuHMdVx5PU--fo+J1c04qcdG6r+B1DJwD6cxR8evFAyVpJBHQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] tracing,x86: Add a TSC trace_clock
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 1:27 AM, David Sharp <dhsharp@google.com> wrote:
> +#include <asm-generic/trace_clock.h>

Please use the Kbuild infrastructure ("generic-y += ..." in
arch/*/include/asm/Kbuild)
instead of adding wrappers around the asm-generic version.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
