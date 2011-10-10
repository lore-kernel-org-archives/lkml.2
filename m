Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1JJIXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:23:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40236 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1JJIXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <20111009093651.GC24198@S2100-06.ap.freescale.net>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
	<20111009093651.GC24198@S2100-06.ap.freescale.net>
Date: Mon, 10 Oct 2011 10:23:53 +0200
Message-ID: <CACRpkdbdz0FE57TdVryKD+X2=1sf-M9NgiZzm+Sm+WYhU6n_bQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 9, 2011 at 11:36 AM, Shawn Guo <shawn.guo@freescale.com> wrote:

>> + * @hog_on_boot: if this is set to true, the regulator subsystem will itself
>                                                ^^^^^^^^^
> s/regulator/pinmux?

Yep!

>> +#endif /* !CONFIG_PINCTRL */
>
> s/!CONFIG_PINCTRL/CONFIG_PINMUX?

Yep!

Foldes into original patch with a fixup comment.

Can I have your Reviewed-by: tag on this subsystem?

Yours,
Linus Walleij
