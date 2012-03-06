Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab2CFKI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:08:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36726 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab2CFKI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:08:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.41.161 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330993336-9538-3-git-send-email-swarren@nvidia.com>
References: <1330993336-9538-1-git-send-email-swarren@nvidia.com>
	<1330993336-9538-3-git-send-email-swarren@nvidia.com>
Date: Tue, 6 Mar 2012 11:08:25 +0100
Message-ID: <CACRpkdaZ8EBBwGis4Odh1EZS=waB0nCSZ-mtUHx48ywE81T5Ng@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] gpio: tegra: Hide tegra_gpio_enable/disable()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 1:22 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Recent pinctrl discussions concluded that gpiolib APIs should in fact do
> whatever is required to mux a GPIO onto pins, by calling pinctrl APIs if
> required. This change implements this for the Tegra GPIO driver, and removes
> calls to the Tegra-specific APIs from drivers and board files.
>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

> Merging note: The first two (or at least the 2nd) patches can go through
> the pinctrl susbsystem without issue.

I will give Grant a chance to comment on the GPIO interaction
doc atleast, then I'll apply them.

> This patch should probably be taken
> through the Tegra tree. Once patch 2 is in pinctrl, and considered stable,
> I can just use that as a dependency for the branch containing this Tegra
> patch. I assume that this series will go into 3.5 not 3.4, but I'm willing
> to be surprised:-)

Should be possible if my pinctrl-tegra-for-next-diet branch is considered
stable and could be pulled into the Tegra tree for further augmenting
by this and other patches!

But I guess you'd need to merge some stable development base
for the rest of the pinctrl stuff as well, shall I freeze the for-next
branch with tegra diet stuff merged on top now? I can promise
to just add new patches on top of that if it helps you.

Is Olof the one to ask?

Yours,
Linus Walleij
