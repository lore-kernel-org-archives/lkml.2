Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2LDKHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:07:43 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37299 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2LDKHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:07:41 -0500
MIME-Version: 1.0
In-Reply-To: <20121203150417.16826.70816.stgit@bob.linux.org.uk>
References: <20121203150310.16826.3363.stgit@bob.linux.org.uk>
	<20121203150417.16826.70816.stgit@bob.linux.org.uk>
Date: Tue, 4 Dec 2012 11:07:41 +0100
X-Google-Sender-Auth: fOdMYFyehWzE0YGudPhU1KcOWa8
Message-ID: <CAMuHMdVJHA+nMNgnY1g1OGqYpSifoeR7u_6s0cCN-jczZSZmKA@mail.gmail.com>
Subject: Re: [PATCH 1/9] goldfish: definitions for Goldfish on x86 platforms
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@linux.intel.com>, Jun Nakajima <jnakajim@gmail.com>
Cc: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 4:04 PM, Alan Cox <alan@linux.intel.com> wrote:
> --- /dev/null
> +++ b/arch/x86/include/asm/goldfish.h
> @@ -0,0 +1,36 @@
> +/*
> + *
> + * arch/x86/include/asm/mach-goldfish/hardware.h

Please don't put file names in header files, they get out of sync too easily.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
