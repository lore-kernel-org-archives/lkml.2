Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1LHW4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:56:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1LHW4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:56:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>, kernel@pengutronix.de,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Date: Thu, 08 Dec 2011 23:55:53 +0100
Message-ID: <4693507.K6tP4YDUh2@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:GbbeQ5xzwHH0CR+EK6xZPNkNJmPx8j4v4HdyGYy/9ZV
 s2wecd+ofXyu8RrLMlEWwd25fVLFOq1LU77mSsJXjnoltaAucg
 0lxGk7CWuf/MUixzmIwOJ4zDY6uzTYBtwT+QlJkygQbPn89BfE
 rUWou6fQ8koSOx/ltg4in0l9uS5ak3Mg0IEbXW2ZhlI8GZMUm8
 n4bwPv0/8m3KEyCuqquyRKlI+gQ68qjdtTdMCrepcEywMvndSh
 pD52OQ3RLD5kwXwxNB+h3BYhG8LEsS0OZpCuxP4yCEQoZIEl3K
 evk6UcZVHurHt7DXKhBjz+t6CVuylDgnHO0gF8DeMMgtlnre0k
 yA2md66TmbL24dIgVs8w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 December 2011 23:40:57 Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Note that there is no support yet for efm32 in mainline, so ARCH_EFM32
> isn't defined.

Since the platform is not yet part of the architecture, it will have
to use device tree based probing when it gets added. I would suggest
only merging drivers for it that can deal with this and do not rely
on platform_data.

Other than that, the driver looks ok to me.

	Arnd
