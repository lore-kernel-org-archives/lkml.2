Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2HVEiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:38:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48131 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab2HVEit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYc-iMgKBNfRmxUFftK78G77qQ8h_Rr5td1-95NGo7wZg@mail.gmail.com>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
	<1345060656-32201-4-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdYc-iMgKBNfRmxUFftK78G77qQ8h_Rr5td1-95NGo7wZg@mail.gmail.com>
Date: Wed, 22 Aug 2012 10:08:48 +0530
Message-ID: <CAJuYYwSaV9=DiAnv_s0yJJGLYUQrEk+P4s0EyX00-P0ae-WEBQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] gpio: exynos4: skip gpiolib registration if
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

On 21 August 2012 17:35, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 15, 2012 at 9:57 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> Pinctrl driver, when enabled, registers all the gpio pins and hence the
>> registration of gpio pins by this driver can be skipped.
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>
>> +#ifdef CONFIG_OF
>
> Wouldn't it be better to use
> #ifdef CONFIG_PINCTRL_SAMSUNG?

Yes, this would be better. I will fix this.

>
> Yours,
> Linus Walleij

Thanks,
Thomas.
