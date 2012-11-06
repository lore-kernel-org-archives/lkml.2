Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2KFIOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:14:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34661 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2KFIOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:14:03 -0500
MIME-Version: 1.0
In-Reply-To: <1352156701-4038-25-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org> <1352156701-4038-25-git-send-email-keescook@chromium.org>
From: Matt Turner <mattst88@gmail.com>
Date: Tue, 6 Nov 2012 00:13:42 -0800
Message-ID: <CAEdQ38F_iJ+x=m25wNdRjt_+OBPaXXRuBndMWGagbbby8ed0dw@mail.gmail.com>
Subject: Re: [PATCH 024/104] arch/alpha: remove depends on CONFIG_EXPERIMENTAL
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anna-Maria Gleixner <anna-maria@glx-um.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 3:03 PM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> CC: Richard Henderson <rth@twiddle.net>
> CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> CC: Matt Turner <mattst88@gmail.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: "Michael S. Tsirkin" <mst@redhat.com>
> CC: Anna-Maria Gleixner <anna-maria@glx-um.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/alpha/Kconfig |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index 5dd7f5d..65ec1c8 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -557,8 +557,7 @@ config NR_CPUS
>            with working support have a maximum of 4 CPUs.
>
>  config ARCH_DISCONTIGMEM_ENABLE
> -       bool "Discontiguous Memory Support (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
> +       bool "Discontiguous Memory Support"
>         help
>           Say Y to support efficient handling of discontiguous physical memory,
>           for architectures which are either NUMA (Non-Uniform Memory Access)
> --
> 1.7.9.5
>

Acked-by: Matt Turner <mattst88@gmail.com>
