Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0F3S1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:27:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39115 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab0F3S1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=gHBAoiM+mxhE8eIq7NyWEQwTfPVoDuzVwQTs6nKILWumUGA/PjA7OTWDLr9U5/E6gK
         YSZhtwlFQgermVKsPWU+44FaaSas1I2cMfD+Tu/9Gdytlt13bIvYiZ72mQMnDGTW2EQL
         G3DVbyKxUjIGwKbh26x4iHWpRoxHeEQvFApL8=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Christoph Egger <siccegge@cs.fau.de>
Subject: Re: [PATCH 18/33] Removing dead OMAP_ARM_96MHZ
Date: Wed, 30 Jun 2010 20:25:14 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
References: <cover.1277911345.git.siccegge@cs.fau.de> <8304abb0dbda307c488b6fe2b3cc8df3c9909eb6.1277911346.git.siccegge@cs.fau.de>
In-Reply-To: <8304abb0dbda307c488b6fe2b3cc8df3c9909eb6.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006302025.14881.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 30. června 2010 17:59:45 Christoph Egger napsal(a):
> OMAP_ARM_96MHZ doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

I'd be for adding it to Kconfig rather than removing from here
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-omap1/opp_data.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/opp_data.c
> b/arch/arm/mach-omap1/opp_data.c index 75a5465..060df86 100644
> --- a/arch/arm/mach-omap1/opp_data.c
> +++ b/arch/arm/mach-omap1/opp_data.c
> @@ -45,9 +45,6 @@ struct mpu_rate omap1_rate_table[] = {
>  #if defined(CONFIG_OMAP_ARM_120MHZ)
>  	{ 120000000, 12000000, 120000000, 0x010a, 0x2510 }, /* 1/1/1/2/4/4 */
>  #endif
> -#if defined(CONFIG_OMAP_ARM_96MHZ)
> -	{  96000000, 12000000,  96000000, 0x0005, 0x2410 }, /* 1/1/1/1/2/2 */
> -#endif
>  #if defined(CONFIG_OMAP_ARM_60MHZ)
>  	{  60000000, 12000000,  60000000, 0x0005, 0x2290 }, /* 1/1/1/1/2/2 */
>  #endif
