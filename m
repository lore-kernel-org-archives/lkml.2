Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab2GQSU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:20:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36400 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab2GQSU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <1341832976-8025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341832976-8025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 17 Jul 2012 20:20:26 +0200
Message-ID: <CACRpkdaxXOzn_h2Gf6+WLr7QeXLzz8DO0KqD8UHGrFKZjZgRpA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Defer failed gpio requests by default
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 1:22 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Since users must be explicitly provided with a GPIO number in order to
> request one the overwhelmingly common case for failing to request will
> be that the required GPIO driver has not yet registered and we should
> therefore defer until it has registered.
>
> In order to avoid having to code this logic in individual drivers have
> gpio_request() return -EPROBE_DEFER when failing to look up the GPIO.
> Drivers which don't want this behaviour can override it if they desire.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Following Greg's application of the required prerequisite patch
I have merged this patch.

Grant, shout if you feel bad about it, ACK if you like it :-)

Linus Walleij
