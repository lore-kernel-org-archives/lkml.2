Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab2KHVif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:38:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61391 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab2KHVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:38:34 -0500
MIME-Version: 1.0
In-Reply-To: <1352341649.19098.1.camel@phoenix>
References: <1352341649.19098.1.camel@phoenix>
Date: Thu, 8 Nov 2012 22:38:32 +0100
Message-ID: <CACRpkdbyJ4zpynfFmUEUXh_WETrPVk6jxMEV09xX+ceWwi8oLg@mail.gmail.com>
Subject: Re: [PATCH] gpio: mvebu: Set free callback for gpio_chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 3:27 AM, Axel Lin <axel.lin@ingics.com> wrote:

> We call pinctrl_request_gpio() in request callback, thus we need to call
> pinctrl_free_gpio() in free callback.
>
> Both mvebu_gpio_request() and mvebu_gpio_free() are not referenced outside of
> this file, make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Thomas' ACK, thanks!

Yours,
Linus Walleij
