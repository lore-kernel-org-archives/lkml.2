Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2DMMrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:47:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46884 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2DMMq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:46:58 -0400
MIME-Version: 1.0
In-Reply-To: <1334184439-16428-1-git-send-email-swarren@wwwdotorg.org>
References: <1334184439-16428-1-git-send-email-swarren@wwwdotorg.org>
Date: Fri, 13 Apr 2012 14:46:58 +0200
Message-ID: <CACRpkdYiWTNQ7hVM4NczyemxOcHWNcK639-yoh2iWc-5_WQB2Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: debugfs enhancements
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:47 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> * Only provide debugfs-relates ops when CONFIG_DEBUG_FS is enabled.
> * Implement pin_config_group_dbg_show op.
> * Implement pin_config_config_dbg_show op.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Linus, this too would be best to take through the Tegra tree. It depends
> on the other two patches I just posted, but to satisfy that, I'll just
> base my branch off of pinctrl once you've applied those branches and its
> stable.

OK that means you need that other patch adding the debug callback to
be in some stable branch so you can pull it into the Tegra
tree I guess?

Can we conclude base stabilization from this and say that the series
of patches upto debugfs enhancements v2 (with the kerneldoc fix)
is the stable merge base, and I'll push some tag for that.

And once that settles:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
