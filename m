Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2IEI0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:26:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46469 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab2IEI0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <1346798370-28795-1-git-send-email-swarren@wwwdotorg.org>
References: <1346798370-28795-1-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 5 Sep 2012 10:26:24 +0200
Message-ID: <CACRpkdaDQtHvtH-gqps5T5c=EZOzFkMVkg0QbOabzT1zQ1kBdQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: move pinconf-tegra.h content into drivers/pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 12:39 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Now that Tegra's pinmux is configured solely from device tree, there's
> no need for the pinconf types to be defined in arch/arm/mach-tegra/.
> Move it into the pinctrl directory to clean up mach-tegra, as a pre-
> requisite for single-zImage.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> I'll need to take this through the Tegra tree, since it depends on some
> patches that remove inclusion of the deleted header.

Go for it:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
