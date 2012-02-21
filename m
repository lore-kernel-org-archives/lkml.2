Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2BUKoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:44:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45299 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2BUKof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:44:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.179.8 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329719263-18971-2-git-send-email-swarren@nvidia.com>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
	<1329719263-18971-2-git-send-email-swarren@nvidia.com>
Date: Tue, 21 Feb 2012 11:44:35 +0100
Message-ID: <CACRpkdYDVU9TAVAAw=uBp84puED0kGkdSW8goAJRG1Nc=6xCaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: tegra: Delete tegra_gpio_enable/disable()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Colin Cross <ccross@android.com>,
        Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:27 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Recent pinctrl discussions concluded that gpio_request() and other gpiolib
> APIs should in fact do whatever is required to mux a GPIO onto pins, by
> calling pinctrl APIs if required. This change implements this for the
> Tegra GPIO driver, and removes the old Tegra-specific APIs which did this.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> I don't believe this depends on other patches.
>
> There may be some slight context dependencies; this patch was generated
> against next-20120217, with my recently posted "gpio: tegra: Fix build
> issue due to irq_domain rework." applied on top.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Since it mainly touches mach-tegra stuff I think it's best to take
this through the Tegra tree, Olof can you queue it?

Yours,
Linus Walleij
