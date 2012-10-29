Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2J2Clq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:41:46 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:49246 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab2J2Clp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:41:45 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <58205.162.105.203.8.1351479644.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1351022666-6960-31-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
    <1351022666-6960-31-git-send-email-keescook@chromium.org>
Date: Mon, 29 Oct 2012 11:00:44 +0800 (CST)
Subject: Re: [PATCH 030/193] arch/unicore32: remove CONFIG_EXPERIMENTAL
To: "Kees Cook" <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "Kees Cook" <keescook@chromium.org>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks. I will push it in my tree.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

> ---
>  arch/unicore32/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index e5c5473..4def59a 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -216,7 +216,7 @@ config PUV3_GPIO
>  	bool
>  	depends on !ARCH_FPGA
>  	select GENERIC_GPIO
> -	select GPIO_SYSFS if EXPERIMENTAL
> +	select GPIO_SYSFS
>  	default y
>
>  if PUV3_NB0916
> --
> 1.7.9.5
>

