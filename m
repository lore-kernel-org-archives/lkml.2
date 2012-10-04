Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2JDMRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:17:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63536 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab2JDMRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:17:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/6] mfd: da9052: Introduce da9052-irq.c
Date: Thu, 4 Oct 2012 12:17:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com> <201210040712.48516.arnd@arndb.de> <20121004111412.GJ4360@opensource.wolfsonmicro.com>
In-Reply-To: <20121004111412.GJ4360@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210041217.28343.arnd@arndb.de>
X-Provags-ID: V02:K0:hmR8lIJjPX6Owf3zi3Z2WFcTeTHp+Tl9Wy9I65WoRm/
 hJrTOHxvfN/fSnP4DlGtS+bZt6s3FM9VnpF9TzFvLLT6mUMDb7
 tzHRclMjE+sqaQVGykE7DLT5hx8EFy7doBNQdw5SExgW4M8taE
 L4CBzewkb9tPmcU94DVeb/PhscdX/3w9PH/C+76hIf5zJo4vT4
 6VJ5AL9r1aP+s3rNaSErIsgRYuTf26pW+NfxRMM1nQ9h4GXNrQ
 zAI9MThmzQq2aPQ8OgzY0PsiTKRhuBYfboGyL/JQ7xtupZHaqy
 deBVOlEBEeABjHUPynBKnWYCE7JXiECuUQlJjn6zKDjcrTdpyi
 2Dao6ae3m5kfo7MD7gNM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2012, Mark Brown wrote:
> Aside from hiding the lookup of the irqdomian a bit there's a couple of
> reasons for existing devices having them:
> 
>  - With some devices like WM8994 the interrupts are optional so it's
>    useful to eat errors due to the interrupts not existing.  With the
>    ability to use linear domains this doesn't matter terribly much as we
>    can just allocate the interrupts even if there's no way they can
>    fire, it was more of an issue when irqdomain wasn't available.
> 
>  - With Arizona we've actually got a bunch of interrupt controllers the
>    interrupts might be allocated to and these functions allow us to hide
>    this mapping from the subdrivers.  This is pretty specialist though.
> 
> but if the interrupts are always requestable it really makes little
> odds, just a matter of taste.

Ok, thanks for the explanation. Since this was my only concern on this
version of the series:

Acked-by: Arnd Bergmann <arnd@arndb.de>
