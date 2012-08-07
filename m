Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab2HGGi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 02:38:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51599 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2HGGi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 02:38:27 -0400
MIME-Version: 1.0
In-Reply-To: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
References: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
Date: Tue, 7 Aug 2012 08:38:26 +0200
Message-ID: <CACRpkdbe95qj1hpZCNRZsLjC7s_N8NgLKrXk=p6gXZDDrj_P8g@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Add gpio functions for Exynos4412
From: Linus Walleij <linus.walleij@linaro.org>
To: Dongjin Kim <tobetter@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 3:57 PM, Dongjin Kim <tobetter@gmail.com> wrote:

> GPIO functions are not registered for Exynos4412 yet,
> therefore exynos4_gpiolib_init() is added to initialize Exynos4412 SoC.
>
> Change-Id: I5945d94c6fbfc309ccf882eba067864a338c04ca

Gerrit change ID:s are not used in the kernel.

> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>

I'd like to have some Samsung feedback on this patch...

Yours,
Linus Walleij
