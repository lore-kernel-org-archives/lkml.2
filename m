Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1LVIYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:24:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41553 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab1LVIYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:24:32 -0500
MIME-Version: 1.0
In-Reply-To: <1323482888.11437.1.camel@phoenix>
References: <1323482888.11437.1.camel@phoenix>
Date: Thu, 22 Dec 2011 16:24:31 +0800
Message-ID: <CAN1soZyNBXw2uOeTLUbZDBOjMMnHWyNwYWQ4Ku5MQVvpk55kFg@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: Include linux/export.h in balloon3.c
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 10:08 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Include linux/export.h to fix below build warning:
>
>  CC      arch/arm/mach-pxa/balloon3.o
> arch/arm/mach-pxa/balloon3.c:85: warning: data definition has no type or storage class
> arch/arm/mach-pxa/balloon3.c:85: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> arch/arm/mach-pxa/balloon3.c:85: warning: parameter names (without types) in function declaration
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/mach-pxa/balloon3.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
> index 5971c46..c35456f 100644
> --- a/arch/arm/mach-pxa/balloon3.c
> +++ b/arch/arm/mach-pxa/balloon3.c
> @@ -13,6 +13,7 @@
>  *  published by the Free Software Foundation.
>  */
>
> +#include <linux/export.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/interrupt.h>
> --
> 1.7.5.4
>
>

Applied
