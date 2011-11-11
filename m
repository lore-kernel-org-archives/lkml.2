Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1KKUcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 15:32:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44302 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1KKUcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 15:32:41 -0500
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <1320955667.27598.72.camel@x61.thuisdomein>
References: <1320955667.27598.72.camel@x61.thuisdomein>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Fri, 11 Nov 2011 14:32:17 -0600
Message-ID: <CAHrUA37j5VdreUxb4gE0f4mAOxQDeAxv=dnHB_d=TPs=Fr-ZqA@mail.gmail.com>
Subject: Re: [PATCH] hexagon: drop selects of bogus Kconfig symbols
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We needed these in the 2.6.3x series, and failed to notice when they went away.

Acked-by: Linas Vepstas <linasvepstas@gmail.com>

On 10 November 2011 14:07, Paul Bolle <pebolle@tiscali.nl> wrote:
> There are no Kconfig symbols named GENERIC_HARDIRQS_NO__DO_IRQ and
> GENERIC_HARDIRQS_NO_DEPRECATED. The two select statements for these
> symbols are nops. Drop these.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested by running "yes "" | make ARCH=hexagon config" before and after
> applying this patch. Identical .config files were generated.
>
>  arch/hexagon/Kconfig |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
> index 02513c2..f03740e 100644
> --- a/arch/hexagon/Kconfig
> +++ b/arch/hexagon/Kconfig
> @@ -18,8 +18,6 @@ config HEXAGON
>        select GENERIC_ATOMIC64
>        select HAVE_PERF_EVENTS
>        select HAVE_GENERIC_HARDIRQS
> -       select GENERIC_HARDIRQS_NO__DO_IRQ
> -       select GENERIC_HARDIRQS_NO_DEPRECATED
>        # GENERIC_ALLOCATOR is used by dma_alloc_coherent()
>        select GENERIC_ALLOCATOR
>        select GENERIC_IRQ_SHOW
> --
> 1.7.4.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-hexagon" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
