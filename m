Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2FABnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:43:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43995 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2FABnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:43:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120531111247.GA9089@faui49q.informatik.uni-erlangen.de>
References: <20120531111247.GA9089@faui49q.informatik.uni-erlangen.de>
Date: Fri, 1 Jun 2012 09:43:38 +0800
Message-ID: <CACRpkdYOCRox+sc+_ffVhsFFZVPJA=ATB7ywNpyEuO4B+i5piQ@mail.gmail.com>
Subject: Re: [PATCH] gpio/msm_v1: CONFIG_GPIO_MSM_V1 is only available on
 three SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 7:12 PM, Christian Dietrich
<christian.dietrich@informatik.uni-erlangen.de> wrote:

> The feature GPIO_MSM_V1 is only available on three SoCs. On all other MSM SoCs
> the INT_GPIO_GROUP{1,2} is undeclared, but Kconfig does allow such
> configurations. Therefore the produced configuration is valid, but does not
> compile. The problem is fixed by adding the missing Kconfig constraints.
>
> drivers/gpio/gpio-msm-v1.c: In function â  msm_init_gpioâ  :
> drivers/gpio/gpio-msm-v1.c:629:26: error: 'INT_GPIO_GROUP1' undeclared
> drivers/gpio/gpio-msm-v1.c:630:26: error: 'INT_GPIO_GROUP2' undeclared
>
> Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>

I've run into this bug when trying (and failing) to build a mainline kernel
for the DragonBoard.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
