Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2IEIWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:22:17 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64890 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2IEIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120905073319.GF4233@gmail.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
	<1345734087-21803-3-git-send-email-lee.jones@linaro.org>
	<20120831112258.GA2624@pengutronix.de>
	<20120905073319.GF4233@gmail.com>
Date: Wed, 5 Sep 2012 10:22:13 +0200
Message-ID: <CACRpkdaFfiejoP263ZVSfHxDV9qg38qiLaDEpQD03RQXjpcO6g@mail.gmail.com>
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org, Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 9:33 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Author: Lee Jones <lee.jones@linaro.org>
> Date:   Mon Aug 6 11:09:57 2012 +0100
>
>     i2c: nomadik: Add Device Tree support to the Nomadik I2C driver
>
>     Here we apply the bindings required for successful Device Tree
>     probing of the i2c-nomadik driver.
>
>     Cc: linux-i2c@vger.kernel.org
>     Signed-off-by: Lee Jones <lee.jones@linaro.org>

Excellent :-)
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Wolfram are you picking this up?

Yours,
Linus Walleij
