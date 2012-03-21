Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2CUVLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:11:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33057 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2CUVLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:11:09 -0400
MIME-Version: 1.0
In-Reply-To: <1332181985-15209-1-git-send-email-dev@snitselaar.org>
References: <1332181985-15209-1-git-send-email-dev@snitselaar.org>
From: Mike Turquette <mturquette@linaro.org>
Date: Wed, 21 Mar 2012 14:10:47 -0700
Message-ID: <CAPtuhTgRpCNBVc5u5Us05wT1tNyAqUM0sAAhyXox8ccA53vr4w@mail.gmail.com>
Subject: Re: [PATCH] drivers/clk: add prompt for menuconfig entry
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:33 AM, Gerard Snitselaar <dev@snitselaar.org> wrote:
> Building next-20120319 gives the following warning:
>
> drivers/clk/Kconfig:22: warning: menuconfig statement without prompt
>
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Hello Gerard,

Thanks for the patch!  This issue was resolved in the following thread:
http://article.gmane.org/gmane.linux.kernel.next/21493

Regards,
Mike

> ---
>  drivers/clk/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 82bcfbd..d857235 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -10,7 +10,7 @@ config HAVE_MACH_CLKDEV
>        bool
>
>  menuconfig COMMON_CLK
> -       bool
> +       bool "Use common clock framework"
>        select HAVE_CLK_PREPARE
>        ---help---
>          The common clock framework is a single definition of struct
> --
> 1.7.7.6
>
