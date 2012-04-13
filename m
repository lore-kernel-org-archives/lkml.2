Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2DMMlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:41:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52963 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2DMMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <1334170839-10396-1-git-send-email-swarren@wwwdotorg.org>
References: <1334170839-10396-1-git-send-email-swarren@wwwdotorg.org>
Date: Fri, 13 Apr 2012 14:41:16 +0200
Message-ID: <CACRpkdZQneBCOGp8oL2O4+J0OnOeW7NUHt2Eo7sKqQ_4jSGKLg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: refactor probe handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 9:00 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Rather than having a single tegra-pinctrl driver that determines whether
> it's running on Tegra20 or Tegra30, instead have separate drivers for
> each that call into utility functions to implement the majority of the
> driver. This change is based on review feedback of the SPEAr pinctrl
> driver, which had originally copied to Tegra driver structure.
>
> This requires that the two drivers have unique names. Update a couple
> spots in arch/arm/mach-tegra for the name change.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Linus, It'll be easiest for me to merge this through the Tegra tree, since
> the arch/arm changes depend on the patches there that switch to using the
> pinctrl driver. If you could ack this, it'd be great. Thanks.

Sure,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
