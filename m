Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab2AWTJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:09:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64608 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2AWTJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:09:29 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6D0CA@EXMAIL03.scwf.nsc.com>
References: <AczXFXB5tuUxDiyyTP+0MvKxJb7yTg==>
	<B567DBAB974C0544994013492B949F8E3812C6D0CA@EXMAIL03.scwf.nsc.com>
Date: Mon, 23 Jan 2012 20:09:29 +0100
Message-ID: <CACRpkdb577CTML0MvXAyYdHqM1LfqMv-x27SQwhwsLvBOLpAtg@mail.gmail.com>
Subject: Re: [PATCH 2/7] leds-lm3530: add 'name' in lm3530_platform_data
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 2:47 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> The led device name can be configurable.

OK, why?

> For the compatibility, the name is set to default value(LM3530_LED_DEV)
> when 'name' is not defined.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Anyway, it doesn't hurt so for me it's:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
