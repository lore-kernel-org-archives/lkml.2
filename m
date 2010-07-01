Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0GACef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 22:34:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40934 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0GACee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 22:34:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t2yotfozB+GrtzsxLc9Re5JfdbKYPaNHQKSdn6NBgTwEoGd37662k0H4Nb8g0sYZIh
         Ps8VeBwLfLlN5WaH9EilkppnS4bi2PF6j8JNkue2XcIo50pe9ZSwKiaRulGuZuBuTz1Q
         9qJ3KOpJSApyX6poZP1WSRzsy7Mg5ExTKI/XI=
MIME-Version: 1.0
In-Reply-To: <b43850b1a1909496718e39687d1ca00543aa30ec.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <b43850b1a1909496718e39687d1ca00543aa30ec.1277911346.git.siccegge@cs.fau.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 1 Jul 2010 10:34:13 +0800
Message-ID: <AANLkTimVRdxeeQKazgFSIQJYtbmHnjDN5lUnTrVv6uoI@mail.gmail.com>
Subject: Re: [PATCH 06/33] Removing dead SHARPSL_LOCOMO
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 11:55 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
> SHARPSL_LOCOMO doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>

A good catch, though SHARPSL_LOCOMO has be changed to SHARP_LOCOMO
later, so a better fix would be the name change only.

> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-sa1100/include/mach/irqs.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-sa1100/include/mach/irqs.h b/arch/arm/mach-sa1100/include/mach/irqs.h
> index 8c8845b..123c6c9 100644
> --- a/arch/arm/mach-sa1100/include/mach/irqs.h
> +++ b/arch/arm/mach-sa1100/include/mach/irqs.h
> @@ -77,8 +77,6 @@
>  */
>  #ifdef CONFIG_SA1111
>  #define NR_IRQS                        (IRQ_BOARD_END + 55)
> -#elif defined(CONFIG_SHARPSL_LOCOMO)
> -#define NR_IRQS                        (IRQ_BOARD_START + 4)
>  #else
>  #define NR_IRQS                        (IRQ_BOARD_START)
>  #endif
> --
> 1.7.0.4
>
>
