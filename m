Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965319Ab2JWUQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:16:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53515 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563Ab2JWUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <1351022666-6960-80-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-80-git-send-email-keescook@chromium.org>
Date: Tue, 23 Oct 2012 13:16:01 -0700
Message-ID: <CAP6odjidF8usR7BNipVquh2SYvv9C7AwrH4iNmws_uLv8TuExg@mail.gmail.com>
Subject: Re: [PATCH 079/193] drivers/net/ethernet/dec/tulip: remove CONFIG_EXPERIMENTAL
From: Grant Grundler <grantgrundler@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Grant Grundler <grundler@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 1:02 PM, Kees Cook <keescook@chromium.org> wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: Grant Grundler <grundler@parisc-linux.org>

Acked-by: Grant Grundler <grundler@parisc-linux.org>

It clearly makes no sense for this driver (obsolete HW for the most part).

Thanks Kees!
grant

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/dec/tulip/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/Kconfig b/drivers/net/ethernet/dec/tulip/Kconfig
> index 1203be0..0c37fb2 100644
> --- a/drivers/net/ethernet/dec/tulip/Kconfig
> +++ b/drivers/net/ethernet/dec/tulip/Kconfig
> @@ -57,8 +57,8 @@ config TULIP
>           be called tulip.
>
>  config TULIP_MWI
> -       bool "New bus configuration (EXPERIMENTAL)"
> -       depends on TULIP && EXPERIMENTAL
> +       bool "New bus configuration"
> +       depends on TULIP
>         ---help---
>           This configures your Tulip card specifically for the card and
>           system cache line size type you are using.
> --
> 1.7.9.5
>
