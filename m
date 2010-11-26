Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0KZL5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:57:05 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62006 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0KZL5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:57:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f47/VjE6C1USv18sroy6BLBLhTd1qf1LSue25cAVUFzEiCfFa1ZasgGtEEllYzGNTe
         0TSRNSSEt/QD9sPHvGii7lu3nulFdY4H0v5d6/ihTyzSmE3nW6+dCSou64yBUtVjETDL
         sPYiwwW2TaDlpJND1/g8pk4J9Z4tLF5ygBTB8=
MIME-Version: 1.0
In-Reply-To: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com>
Date: Fri, 26 Nov 2010 12:57:02 +0100
Message-ID: <AANLkTikkVqWgpYEg505DwQ+pSegQv1g-Q8cDEpE-JCrV@mail.gmail.com>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/20 Hans Ulli Kroll <ulli.kroll@googlemail.com>:
> Add support for PCI Bus on Gemini Devices SL3516
>
> Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> ---
[...]
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a19a526..5d4b398 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -307,6 +307,7 @@ config ARCH_GEMINI
>        select CPU_FA526
>        select ARCH_REQUIRE_GPIOLIB
>        select ARCH_USES_GETTIMEOFFSET
> +       select PCI
>        help
>          Support for the Cortina Systems Gemini family SoCs
>
[...]

I think it's better to add ARCH_GEMINI to CONFIG_PCI dependencies.
AFAIK IB-4220B NAS does not use PCI and doesn't need all that code.
Board support entries could select PCI if the board is useless without
it.

Best Regards,
Micha³ Miros³aw
