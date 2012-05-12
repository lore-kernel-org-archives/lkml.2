Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2ELXUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 19:20:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60909 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab2ELXT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 19:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <1335959206-8138-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1335959206-8138-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1335959206-8138-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sun, 13 May 2012 01:19:58 +0200
Message-ID: <CACRpkdZCjCEaudWb+pdd_cvWaLs_W5-Mo+2CWcfopkRorMZBSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 1:46 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Allow drivers to use the modern request and configure idiom together
> with devres.
>
> As with plain gpio_request() and gpio_request_one() we can't implement
> the old school version in terms of _one() as this would force the
> explicit selection of a direction in gpio_request() which could break
> systems if we pick the wrong one.  Implementing devm_gpio_request_one()
> in terms of devm_gpio_request() would needlessly complicate things or
> lead to duplication from the unmanaged version depending on how it's
> done.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
