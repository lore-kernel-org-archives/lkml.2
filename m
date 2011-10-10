Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1JJISl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:18:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65352 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1JJISk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <15e5a354.4381.132e6876087.Coremail.hongjiujing@126.com>
References: <1317629883-13582-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4wJogkvhoJ0JNJGbv9FvaA7zHxFKRwvkXdY0g5SbLXuJA@mail.gmail.com>
	<15e5a354.4381.132e6876087.Coremail.hongjiujing@126.com>
Date: Mon, 10 Oct 2011 10:18:39 +0200
Message-ID: <CACRpkdZCDoiZEm=vX6xW52EbG4E-DMBvo8A3rF9T6TrfOX6O-g@mail.gmail.com>
Subject: Re: Re: [PATCH 2/2] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: "tommy.hong" <hongjiujing@126.com>
Cc: Barry Song <21cnbao@gmail.com>, Linaro Dev <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/9 tommy.hong <hongjiujing@126.com>:
> [Barry]
>>is this a debug information or do you want it to be in mainline?
>>
> Hi,Barry,should dumpregs function need "CONFIG_XXX_DEBUG" when probe ?and if
> driver meet some issue or error,we can use dumpregs to trace?

You can add any debug stuff you want if it helps development
and/or transparance of the driver, but this stuff I just deleted, it
is not needed anymore. I just used it to figure out the default
reset-values of the registers.

Yours,
Linus Walleij
