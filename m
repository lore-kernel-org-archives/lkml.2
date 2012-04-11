Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2DKHbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:31:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43470 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2DKHbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:31:36 -0400
MIME-Version: 1.0
In-Reply-To: <1333616843-3607-1-git-send-email-b29396@freescale.com>
References: <1333616843-3607-1-git-send-email-b29396@freescale.com>
Date: Wed, 11 Apr 2012 09:31:35 +0200
Message-ID: <CACRpkdbWm8DbN33FT2YONNYcq2M4KrK5VSf3Yo2p3YJXucoZ=Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: fix compile error if not select PINMUX support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, swarren@wwwdotorg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 11:07 AM, Dong Aisheng <b29396@freescale.com> wrote:

> From: Dong Aisheng <dong.aisheng@linaro.org>
>
> The pinctrl_register_mappings is defined in core.c, so change the dependent
> macro from CONFIG_MUX to CONFIG_PINCTRL.
>
> The compile error message is:
> drivers/pinctrl/core.c:886: error: redefinition of 'pinctrl_register_mappings'
> include/linux/pinctrl/machine.h:160: note: previous definition of 'pinctrl_register_mappings' was here
> make[2]: *** [drivers/pinctrl/core.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Thanks, applied.

(Catching up with the patch queue...)

Yours,
Linus Walleij
