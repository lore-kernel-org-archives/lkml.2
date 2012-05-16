Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020Ab2EPH7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:59:34 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54176 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2EPH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:59:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120516075754.GG10347@shlinux2.ap.freescale.net>
References: <1337010369-28687-1-git-send-email-b29396@freescale.com>
	<CACRpkdbW8eeq0gFTjPRpKesmV4K5zqRHuW6C-UywBn8AtqOLCg@mail.gmail.com>
	<20120515112732.GB10347@shlinux2.ap.freescale.net>
	<CACRpkdaKAF8bznd-sBdcGfdJW_cHSUGFZhnVk4qJ_0LJ8GoUuQ@mail.gmail.com>
	<20120516021301.GA21517@S2100-06.ap.freescale.net>
	<CACRpkdZw5Sag5dmpqadTPJyaT5hex1CnASeVRKT5FXWtOKijkQ@mail.gmail.com>
	<20120516075754.GG10347@shlinux2.ap.freescale.net>
Date: Wed, 16 May 2012 09:59:32 +0200
Message-ID: <CACRpkdZYFiaUDkJAov=ggOknXw6gVf=Bh8+7wLyXVQO1xtLw0w@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: add imx53 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Guo Shawn-R65073 <r65073@freescale.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 9:57 AM, Dong Aisheng
<aisheng.dong@freescale.com> wrote:
> On Wed, May 16, 2012 at 02:50:48PM +0800, Linus Walleij wrote:
>> On Wed, May 16, 2012 at 4:13 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>>
>> > With the patches going in via pinctrl tree, we can start making machine
>> > changes from next cycle.
>>
>> Shawn are these patches OK with you? It'd be nice to have some
>> Acked-by: since they are quite big.
>>
> Shawn said he's ok with it, but he's not available right now.
> Maybe you could hold a few hours to wait for his tag if needed.

There's no super-hurry, I just want it at some point if possible...

Linus Walleij
