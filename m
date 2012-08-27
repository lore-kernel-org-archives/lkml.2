Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2H0XJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:09:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55352 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2H0XJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:09:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120820115914.GP8450@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-5-git-send-email-lee.jones@linaro.org>
	<CACRpkda_xOyu9BFGRK4xTsXOO9RCJu7BbU-kPGpttVkR6mDMZg@mail.gmail.com>
	<20120820115914.GP8450@gmail.com>
Date: Mon, 27 Aug 2012 16:09:46 -0700
Message-ID: <CACRpkdZse9Nq1acoAujV8ojhRKxykNX0ymcr51QAoanUbDW14g@mail.gmail.com>
Subject: Re: [PATCH 04/22] ASoC: Ux500: Move MSP pinctrl setup into the MSP driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com,
        Patrice CHOTARD <patrice.chotard@stericsson.com>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 4:59 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, Aug 14, 2012 at 10:51:02AM +0200, Linus Walleij wrote:

>> But wait. These are just local statics. Surelty you can put these into
>> struct ux500_msp instead? Here it looks like these will be used for
>> all ports, so MSP2 will enable the pins requested by MSP1 etc
>> completely broken. So put it into the struct ux500_msp state
>> container from ux500_msp_i2s.h where it belongs.
>>
>> Refer to drivers/tty/serial/amba-pl011.c when in trouble. This
>> one is a good pinctrl example.
>
> How do you see the MSP1 and MSP3 usage protection working if I hide it
> all away in MSP specific structs?

Usage protection? Sorry not following. Please elaborate...

Yours,
Linus Walleij
