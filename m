Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab2JLRQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:16:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48774 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab2JLRQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:16:41 -0400
MIME-Version: 1.0
In-Reply-To: <21143.1349774135@warthog.procyon.org.uk>
References: <21143.1349774135@warthog.procyon.org.uk>
Date: Fri, 12 Oct 2012 19:16:39 +0200
X-Google-Sender-Auth: xCjrKW2O8uG4qpC5wnnDKaiuPIw
Message-ID: <CAMuHMdXYg+GGHwpYZmVff79SU_MhX+uiLtbmY5UH+BObiHvrXw@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate UAPI for m68k [ver #2]
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 11:15 AM, David Howells <dhowells@redhat.com> wrote:
>  arch/m68k/include/asm/ptrace.h                 |  72 +----

This leaves the following empty construct:

    #ifdef CONFIG_COLDFIRE
    #else
    #endif

I'll remove it in a subsequent patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
