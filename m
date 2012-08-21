Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2HUMFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:05:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58412 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab2HUMFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <1345060656-32201-4-git-send-email-thomas.abraham@linaro.org>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
	<1345060656-32201-4-git-send-email-thomas.abraham@linaro.org>
Date: Tue, 21 Aug 2012 14:05:22 +0200
Message-ID: <CACRpkdYc-iMgKBNfRmxUFftK78G77qQ8h_Rr5td1-95NGo7wZg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] gpio: exynos4: skip gpiolib registration if
 pinctrl driver is used
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 9:57 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Pinctrl driver, when enabled, registers all the gpio pins and hence the
> registration of gpio pins by this driver can be skipped.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>

> +#ifdef CONFIG_OF

Wouldn't it be better to use
#ifdef CONFIG_PINCTRL_SAMSUNG?

Yours,
Linus Walleij
