Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3AFXb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 18:31:27 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:44399 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3AFXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 18:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <017801cde453$77b03eb0$6710bc10$@samsung.com>
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
	<1355399644-29417-2-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdaQ10CgoFXtk4EyqL4LWVpsdEAdrmy5R-_Rqm5fJdqS4A@mail.gmail.com>
	<CAJuYYwTZkzCXjowhKaJ253Oji07eDdEjMvNssyL1ThWtETswSQ@mail.gmail.com>
	<017801cde453$77b03eb0$6710bc10$@samsung.com>
Date: Mon, 7 Jan 2013 00:31:25 +0100
Message-ID: <CACRpkdZKB1_1U1VZfYADwWfFpBum0Qc88kWtW37h7Z05RtSJfA@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: exynos: add exynos5250 SoC specific data
From: Linus Walleij <linus.walleij@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 5:58 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:

> And I think, would be clear if the config could be changed like following.
>
> 8<----------------------------------------------------------------------
> From: Kukjin Kim <kgene.kim@samsung.com>
> Subject: [PATCH] pinctrl: exynos: change PINCTRL_EXYNOS option
>
> Since pinctrl-exynos can support exynos4 and exynos5 so changed
> the option name to PINCTRL_EXYNOS for more clarity.
>
> Cc: Thomas Abraham <Thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Shall I take this into the pinctrl tree?

Yours,
Linus Walleij
