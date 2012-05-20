Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2ETUxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 16:53:45 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63694 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2ETUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 16:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <1337262323-27692-2-git-send-email-lee.jones@linaro.org>
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
	<1337262323-27692-2-git-send-email-lee.jones@linaro.org>
Date: Sun, 20 May 2012 22:53:41 +0200
Message-ID: <CACRpkdZFZCvK_Dt4HvxPrVNU6UN7YPm3xY_kPruaGCGuX2CM0Q@mail.gmail.com>
Subject: Re: [PATCH 01/18] i2c: Add Device Tree support to the Nomadik I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, w.sang@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 3:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we move the i2c-nomadik's default settings into the driver
> rather than specifying them from platform code. At the time of
> this writing we only have one user, the u8500. As new users are
> added, it is expected that they will be Device Tree compliant.
> If this is the case, we will look up their initialisation values
> by compatible entry, then apply them forthwith.
>
> Cc: linux-i2c@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Nice!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

BTW: you want to CC Wolfram on the I2C patches.

Yours,
Linus Walleij
