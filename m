Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2H3XqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:46:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44346 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2H3XqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:46:19 -0400
MIME-Version: 1.0
In-Reply-To: <1345816913-4113-2-git-send-email-lee.jones@linaro.org>
References: <1345816913-4113-1-git-send-email-lee.jones@linaro.org>
	<1345816913-4113-2-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 Aug 2012 16:46:17 -0700
Message-ID: <CACRpkdai+RObHsq7xe0+Fk24K7r-Wzoc8o3RbvHT78=EeHkjSQ@mail.gmail.com>
Subject: Re: [PATCH 01/17] ASoC: Ux500: Move MSP pinctrl setup into the MSP driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        roger.xr.nilsson@stericsson.com, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 7:01 AM, Lee Jones <lee.jones@linaro.org> wrote:

> In the initial submission of the MSP driver msp1 and msp3's associated
> pinctrl mechanism was passed back to platform code using a plat_init()
> call-back routine, but it has no place in platform code. The MSP driver
> should set this up for the appropriate ports. Instead we use a use_pinctrl
> identifier which is passed from platform_data/Device Tree which indicates
> which ports should use pinctrl.
>
> CC: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks good to me, so Acked-by: Linus Walleij <linus.walleij@linaro.org>
for the ux500 mach part.

However I'd request Ola/Roger to ACK it too on the ALSA side.

Yours,
Linus Walleij
