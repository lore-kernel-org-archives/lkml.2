Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2HVEji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:39:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45845 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2HVEjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:39:35 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaxSZZQwefN3FNvv3ctXFHqaLZoAZ5f8CVu7Tx9n6-v1Q@mail.gmail.com>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
	<1345060656-32201-5-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdaxSZZQwefN3FNvv3ctXFHqaLZoAZ5f8CVu7Tx9n6-v1Q@mail.gmail.com>
Date: Wed, 22 Aug 2012 10:09:34 +0530
Message-ID: <CAJuYYwTsYNWRo7uraELdv=KJvXm-7F9JFb9ZrFvEYrcwJvBMmA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ARM: EXYNOS: skip wakeup interrupt setup if
 pinctrl driver is used
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2012 17:34, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 15, 2012 at 9:57 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> Pinctrl driver includes support for configuring the external wakeup
>> interrupts. On exynos platforms that use pinctrl driver, the setup
>> of wakeup interrupts in the exynos platform code can be skipped.
>>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>
>> +#ifdef CONFIG_OF
>
> Don't you actually want to use:
>
> #fidef CONFIG_PINCTRL_SAMSUNG
>
> here? CONFIG_OF is a bit vague.

Ok. I will use CONFIG_PINCTRL_SAMSUNG here.

>
> Yours,
> Linus Walleij

Thanks,
Thomas.
