Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2JEHDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:03:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49785 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2JEHDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:03:39 -0400
MIME-Version: 1.0
In-Reply-To: <17383.1349380286@warthog.procyon.org.uk>
References: <17383.1349380286@warthog.procyon.org.uk>
Date: Fri, 5 Oct 2012 07:05:43 +0200
X-Google-Sender-Auth: cUDRM8Uy8K2FgCwKgpcI67ytPnE
Message-ID: <CAMuHMdWYdKPgVR8hvcXN1qmm7nqCyjWV3NPHzdVHG_H8F20-3w@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate UAPI for m68k
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 9:51 PM, David Howells <dhowells@redhat.com> wrote:
>   git://git.infradead.org/users/dhowells/linux-headers.git disintegrate-m68k
>
> for you to fetch changes up to b039235da939b28c539b3e1b4566107a9bdbdef8:
>
>   UAPI: (Scripted) Disintegrate arch/m68k/include/asm (2012-10-04 18:20:56 +0100)
>
> ----------------------------------------------------------------
> David Howells (6):
>       UAPI: Fix the guards on various asm/unistd.h files
>       UAPI: Split compound conditionals containing __KERNEL__ in Arm64
>       Merge remote-tracking branch 'c6x/for-linux-next' into uapi-prep
>       UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k)
>       UAPI: (Scripted) Disintegrate include/asm-generic
>       UAPI: (Scripted) Disintegrate arch/m68k/include/asm
>
> Mark Salter (2):
>       c6x: make dsk6455 the default config
>       c6x: remove c6x signal.h

I assume these c6x and asm-generic changes are the ones you just asked Linus
to pull? Doesn't it make more sense to ask us (the individual arch maintainers)
to pull our parts after Linus has pulled the generic part?

Do you want this ("our parts") to go in 3.7 or 3.8?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
