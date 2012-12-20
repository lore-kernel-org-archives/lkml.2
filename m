Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2LTSEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:04:06 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54626 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2LTSD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:03:59 -0500
MIME-Version: 1.0
In-Reply-To: <001c01cddbfa$b9f858e0$2de90aa0$%choi@samsung.com>
References: <001c01cddbfa$b9f858e0$2de90aa0$%choi@samsung.com>
Date: Thu, 20 Dec 2012 19:03:55 +0100
Message-ID: <CACRpkdb54Y-9baaVYwFU0T4DzM_h8Jt1eNs80OmzKO4w5moU9Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: exynos5440: Fix compile error in pinctrl-exynos5440/samsung.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 3:03 AM, Jonghwan Choi <jhbird.choi@samsung.com> wrote:

> error: drivers/pinctrl/pinctrl-exynos5440.o: multiple definition of 'pcfgs'
> drivers/pinctrl/pinctrl-samsung.o: previous definition here
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Patch applied.

Yours,
Linus Walleij
