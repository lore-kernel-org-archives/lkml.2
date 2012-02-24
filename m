Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2BXGOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:14:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2BXGOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:14:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.42.18.195 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330041880-12406-2-git-send-email-swarren@nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
	<1330041880-12406-2-git-send-email-swarren@nvidia.com>
Date: Fri, 24 Feb 2012 07:14:48 +0100
Message-ID: <CACRpkdYjtKqNiOUn4ydS1bgw93BgKK-7nMA59ZGNL-ohsXshvA@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: Re-order struct pinctrl_map
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 1:04 AM, Stephen Warren <swarren@nvidia.com> wrote:

> The lookup key in struct pinctrl_map is (.dev_name, .name). Re-order the
> struct definition to put the lookup key fields first, and the result
> values afterwards. To me at least, this slightly better reflects the
> lookup process.
>
> Update the documentation in a similar fashion.
>
> Note: PIN_MAP*() macros aren't updated; I plan to update this once later
> when enhancing the mapping table format to support pin config to reduce
> churn.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Rebased and applied with Dong's ACK.

Thanks,
Linus Walleij
