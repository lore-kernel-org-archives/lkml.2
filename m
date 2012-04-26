Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2DZJLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:11:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61358 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2DZJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <1335384209-23065-1-git-send-email-swarren@wwwdotorg.org>
References: <1335384209-23065-1-git-send-email-swarren@wwwdotorg.org>
Date: Thu, 26 Apr 2012 11:03:37 +0200
Message-ID: <CACRpkdZiq1DvjpDZEw6xRe2gk_AVPrLHXD_3iXayZXQkNHHAhQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: error reporting cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:03 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Print an explicit error message in various failure cases to allow
> easier diagnosis.
>
> WARN_ON() some internal failures that users/clients shouldn't be able to
> trigger.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Linus, I intend to take this through the Tegra tree; it most likely depends
> on other stuff in the Tegra repo's gpio-pinmux branch.

Fair enough,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
