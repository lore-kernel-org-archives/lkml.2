Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0GAOlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:41:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59933 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0GAOlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X+K8eyrbSyccbr33t7Vj2yfXeYZ/y2d+b/9N2J0oMdHGlBRLVTxTnRMOGmFhAqJzs6
         kKqILw9fXm4dmCouBsGbFZWGwZqUSLjKYTvNE0s9DqGTlGu/RUfTlhgaMhPo6HOxOWSL
         w16jDcNNwpnJxSLZEOXCWaZOVZqWPSQNIznGY=
MIME-Version: 1.0
In-Reply-To: <20100701132351.GB32541@faui48a.informatik.uni-erlangen.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <b43850b1a1909496718e39687d1ca00543aa30ec.1277911346.git.siccegge@cs.fau.de> 
	<AANLkTimVRdxeeQKazgFSIQJYtbmHnjDN5lUnTrVv6uoI@mail.gmail.com> 
	<20100701132351.GB32541@faui48a.informatik.uni-erlangen.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 1 Jul 2010 22:40:51 +0800
Message-ID: <AANLkTilxNz_iEWKtgvLHjce6PTN_G-7bt2jxeLbIXxVa@mail.gmail.com>
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

On Thu, Jul 1, 2010 at 9:23 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
> On Thu, Jul 01, 2010 at 10:34:13AM +0800, Eric Miao wrote:
>> On Wed, Jun 30, 2010 at 11:55 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
>> > SHARPSL_LOCOMO doesn't exist in Kconfig, therefore removing all
>> > references for it from the source code.
>> >
>>
>> A good catch, though SHARPSL_LOCOMO has be changed to SHARP_LOCOMO
>> later, so a better fix would be the name change only.
>
> Hi! Updated patch below
>
> ----
> From: Christoph Egger <siccegge@cs.fau.de>
> Date: Wed, 30 Jun 2010 12:36:20 +0200
> Subject: [PATCH 06/33] Replacing dead SHARPSL_LOCOMO with SHARP_LOCOMO
>
> SHARP_LOCOMO doesn't exist in Kconfig, therefore replacing all
> references for it with SHARP_LOCOMO in the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  arch/arm/mach-sa1100/include/mach/irqs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-sa1100/include/mach/irqs.h b/arch/arm/mach-sa1100/include/mach/irqs.h
> index 8c8845b..d18f21a 100644
> --- a/arch/arm/mach-sa1100/include/mach/irqs.h
> +++ b/arch/arm/mach-sa1100/include/mach/irqs.h
> @@ -77,7 +77,7 @@
>  */
>  #ifdef CONFIG_SA1111
>  #define NR_IRQS                        (IRQ_BOARD_END + 55)
> -#elif defined(CONFIG_SHARPSL_LOCOMO)
> +#elif defined(CONFIG_SHARP_LOCOMO)
>  #define NR_IRQS                        (IRQ_BOARD_START + 4)
>  #else
>  #define NR_IRQS                        (IRQ_BOARD_START)
> --
> 1.7.0.4
>
>
>
