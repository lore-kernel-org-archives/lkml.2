Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab2ERRHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:07:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab2ERRG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120518163107.510619939@glx-um.de>
References: <20120518163020.548627576@glx-um.de> <20120518163107.510619939@glx-um.de>
From: Matt Turner <mattst88@gmail.com>
Date: Fri, 18 May 2012 13:06:37 -0400
Message-ID: <CAEdQ38EwX2gXcJfPDQWAaje97xARxqU0aGC5gosvhqqzbRPqdQ@mail.gmail.com>
Subject: Re: [patch 24/24] alpha: Use generic time config
To: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:45 PM, Anna-Maria Gleixner
<anna-maria@glx-um.de> wrote:
> Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
> Cc: Matt Turner <mattst88@gmail.com>
> ---
>  arch/alpha/Kconfig |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> Index: linux/arch/alpha/Kconfig
> ===================================================================
> --- linux.orig/arch/alpha/Kconfig
> +++ linux/arch/alpha/Kconfig
> @@ -15,6 +15,7 @@ config ALPHA
>        select GENERIC_IRQ_SHOW
>        select ARCH_WANT_OPTIONAL_GPIOLIB
>        select ARCH_HAVE_NMI_SAFE_CMPXCHG
> +       select GENERIC_CMOS_UPDATE
>        help
>          The Alpha is a 64-bit general-purpose processor designed and
>          marketed by the Digital Equipment Corporation of blessed memory,
> @@ -47,9 +48,6 @@ config GENERIC_CALIBRATE_DELAY
>        bool
>        default y
>
> -config GENERIC_CMOS_UPDATE
> -        def_bool y
> -
>  config GENERIC_GPIO
>        bool

Acked-by: Matt Turner <mattst88@gmail.com>
