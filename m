Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1LCWvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 17:51:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38738 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1LCWvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 17:51:53 -0500
Message-ID: <4EDAA785.40503@solonet.org.ua>
Date: Sun, 04 Dec 2011 00:49:41 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 12/02/2011 03:56 PM, Linus Walleij wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> Simple HV LED controller driver for AB5500v1.0 MFD chips
> 
> Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Tested-by: Naga Radesh Y <naga.radheshy@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
(snip)
> diff --git a/drivers/leds/leds-ab5500.c b/drivers/leds/leds-ab5500.c
(snip)
> +/*
> + * Driver for HVLED in ST-Ericsson AB5500 analog baseband controller
> + *
> + * This chip can drive upto 3 leds, of upto 40mA of led sink current.

Can't get these are High Voltage or High Current LEDs?
If Voltage why haven't you wrote about supplied voltage but wrote about
max. current?

-- 
Best regards, Denis Kuzmenko.
