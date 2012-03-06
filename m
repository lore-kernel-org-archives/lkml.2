Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2CFKDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:03:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47724 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab2CFKDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:03:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.156.196 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330993336-9538-2-git-send-email-swarren@nvidia.com>
References: <1330993336-9538-1-git-send-email-swarren@nvidia.com>
	<1330993336-9538-2-git-send-email-swarren@nvidia.com>
Date: Tue, 6 Mar 2012 11:03:23 +0100
Message-ID: <CACRpkdYdSaNsrr34o2Cc4vS12ee9oY7FG0pxB92mefHZKwdEpA@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] pinctrl: allow concurrent gpio and mux function
 ownership of pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 1:22 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Per recent updates to Documentation/gpio.txt, gpiolib drivers should
> inform pinctrl when a GPIO is requested. pinctrl then marks that pin as
> in-use for that GPIO function.
>
> When an SoC muxes pins in a group, it's quite possible for the group to
> contain e.g. 6 pins, but only 4 of them actually be needed by the HW
> module that's mux'd to them. In this case, the other 2 pins could be
> used as GPIOs. However, pinctrl marks all the pins within the group as
> in-use by the selected mux function. To allow the expected gpiolib
> interaction, separate the concepts of pin ownership into two parts: One
> for the mux function and one for GPIO usage. Finally, allow those two
> ownerships to exist in parallel.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Good, and 100% in accordance with earlier discussions.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
