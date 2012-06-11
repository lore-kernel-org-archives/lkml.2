Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab2FKUve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:51:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41414 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2FKUvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:51:32 -0400
MIME-Version: 1.0
In-Reply-To: <1339211276-31626-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1339211276-31626-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 11 Jun 2012 22:51:31 +0200
Message-ID: <CACRpkdZkMggKLtiJbe_-D00v2bSodqcRiQJcfuFR4jhE=EUSDg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: wm8994: Pay attention to the value set when
 enabling as output
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 5:07 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Not paying attention to the value being set is a bad thing because it
> means that we'll not set the hardware up to reflect what was requested.
> Not setting the hardware up to reflect what was requested means that the
> caller won't get the results they wanted.
> `
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@vger.kernel.org

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
