Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2FDRKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:10:23 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51903 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2FDRKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <000101cd41f8$251e4cd0$6f5ae670$%han@samsung.com>
References: <000101cd41f8$251e4cd0$6f5ae670$%han@samsung.com>
Date: Mon, 4 Jun 2012 19:10:21 +0200
Message-ID: <CACRpkdaM2VbieCY5deDDHCXEH+gHXJndpYVbXENSbWU4t-_YsA@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: fix build error for EXYNOS5250
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 4:17 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Fixed a typo from "exonys5_gpios_1" to "exonys5_gpios_1"
> in order to fix build error as below:
>
> drivers/gpio/gpio-samsung.c: In function 'exynos5_gpiolib_init':
> drivers/gpio/gpio-samsung.c:2836: error: 'exonys5_gpios_1' undeclared (first use in this function)
> drivers/gpio/gpio-samsung.c:2836: error: (Each undeclared identifier is reported only once
> drivers/gpio/gpio-samsung.c:2836: error: for each function it appears in.)
>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
