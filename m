Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab1JaSF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 14:05:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51473 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab1JaSFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 14:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <1316117394-21666-6-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
	<1316117394-21666-6-git-send-email-andi@firstfloor.org>
Date: Mon, 31 Oct 2011 19:05:24 +0100
X-Google-Sender-Auth: pQ0ZMnr8TZNk4N3xmNAl0qp5J2k
Message-ID: <CAMuHMdVq8BHbw66Wk9OkkSsQErHj+tu7b9885bqvYf_MG-8m7g@mail.gmail.com>
Subject: Re: [PATCH 05/27] Initconst section fixes for M68K
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 22:09, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Cc: geert@linux-m68k.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  arch/m68k/emu/nfeth.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
> index c5748bb..a985a7e 100644
> --- a/arch/m68k/emu/nfeth.c
> +++ b/arch/m68k/emu/nfeth.c
> @@ -39,7 +39,7 @@ enum {
>  #define MAX_UNIT       8
>
>  /* These identify the driver base version and may not be removed. */
> -static const char version[] __devinitdata =
> +static const char version[] __devinitconst =
>        KERN_INFO KBUILD_MODNAME ".c:v" DRV_VERSION " " DRV_RELDATE
>        " S.Opichal, M.Jurik, P.Stehlik\n"
>        KERN_INFO " http://aranym.org/\n";

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
