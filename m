Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2HFOAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:00:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57168 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2HFOAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <1344255947-10062-1-git-send-email-lee.jones@linaro.org>
References: <1344255947-10062-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 6 Aug 2012 16:00:04 +0200
Message-ID: <CACRpkdZoJxyZX6SOcAvBP4NBmGyUEiyLH_n_RzSDTBsjS13zug@mail.gmail.com>
Subject: Re: [PATCH 1/1] i2c: Add default configuration into the Nomadik I2C driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, srinidhi.kasagar@stericsson.com,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 2:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> At this moment in time there is only one known configuration for the
> Nomadik I2C driver. By not holding that configuration in the driver
> adds some unnecessary overhead in platform code. The configuration
> as already been removed from platform code, this patch checks for any
> over-riding configurations. If there aren't any, the default is used.
>
> Cc: linux-i2c@vger.kernel.org
> Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This still does not apply for me on v3.6-rc1 what did you base
this patch on?

Applying: i2c: Add default configuration into the Nomadik I2C driver.
error: patch failed: drivers/i2c/busses/i2c-nomadik.c:899
error: drivers/i2c/busses/i2c-nomadik.c: patch does not apply
Patch failed at 0001 i2c: Add default configuration into the Nomadik I2C driver.
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

Yours,
Linus Walleij
