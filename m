Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1JQCUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 22:20:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35017 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab1JQCT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 22:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <1318595280.6132.61.camel@x61.thuisdomein>
References: <1318595280.6132.61.camel@x61.thuisdomein>
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Mon, 17 Oct 2011 11:19:37 +0900
X-Google-Sender-Auth: 0ueNwn5tWKcxGf5RUvcCfVnqvGw
Message-ID: <CABMQnVKZjCC7Qjg+8NRQTwekdxKHjWG0=2ceSacvtEfuD9Qp1w@mail.gmail.com>
Subject: Re: [PATCH 05/21] sh: drop unused Kconfig symbol
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested with this patch. I didn't have any problem.

Tested-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

2011/10/14 Paul Bolle <pebolle@tiscali.nl>:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/sh/Kconfig |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index ff9177c..2d39594 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -101,10 +101,6 @@ config GENERIC_LOCKBREAK
>        def_bool y
>        depends on SMP && PREEMPT
>
> -config SYS_SUPPORTS_PM
> -       bool
> -       depends on !SMP
> -
>  config ARCH_SUSPEND_POSSIBLE
>        def_bool n
>
> --
> 1.7.4.4
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Nobuhiro Iwamatsu
