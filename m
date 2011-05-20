Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551Ab1ETKFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:05:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935394Ab1ETKFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:05:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: mxs: remove gpio driver from mach-mxs
Date: Fri, 20 May 2011 12:04:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, kernel@pengutronix.de
References: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org> <1305885446-27404-2-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1305885446-27404-2-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201204.59237.arnd@arndb.de>
X-Provags-ID: V02:K0:E6wYubSUI90WIG0CjNX9cBq7jV9GwZwZ4vGaHi7PGe+
 kjeks31NXOpxMGUktT15oNYXnpR5VjdgJhzEFZdY1KeK2ohpT7
 GSb+R5kTX5OKuFCNmagi5ed+25mVuSphwUq4Qo7hiXkDh+GxCq
 FXhn5VCqAdJYztV6lLZUY/JQiDN/AOGUzFTZ32I1KJaadf06tj
 QtEyrbJOirwTZKrDofMdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 11:57:24 Shawn Guo wrote:
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  arch/arm/mach-mxs/Makefile       |    2 +-
>  arch/arm/mach-mxs/gpio.c         |  331 --------------------------------------
>  arch/arm/mach-mxs/gpio.h         |   34 ----
>  arch/arm/mach-mxs/mach-mx28evk.c |    1 -
>  arch/arm/mach-mxs/mm-mx23.c      |    1 -
>  arch/arm/mach-mxs/mm-mx28.c      |    1 -
>  6 files changed, 1 insertions(+), 369 deletions(-)
>  delete mode 100644 arch/arm/mach-mxs/gpio.c
>  delete mode 100644 arch/arm/mach-mxs/gpio.h

The patch looks good (removing stuff often is), but
you are missing a changelog. Please explain why it's
not used any more so that people can find it later
when they only look at git but not at your original
mail 0/3 or the entire series.

	Arnd
