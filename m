Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2ETGAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 02:00:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49766 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2ETGAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 02:00:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120520021009.GA5810@S2100-06.ap.freescale.net>
References: <1337417751-24848-1-git-send-email-shawn.guo@linaro.org>
 <20120519181242.B87193E03B8@localhost> <20120520021009.GA5810@S2100-06.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 20 May 2012 00:00:02 -0600
X-Google-Sender-Auth: Gsab5YylunIuiZkillYk-r2MAdQ
Message-ID: <CACxGe6v4omSoBJKePr4MgYvuQ3bQkYt2EcLF1BZBzMSewbkNyg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio/generic: initialize basic_mmio_gpio shadow
 variables properly
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ryan Mallon <rmallon@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>, LW@karo-electronics.de,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 8:10 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Sat, May 19, 2012 at 12:12:42PM -0600, Grant Likely wrote:
>> On Sat, 19 May 2012 16:55:51 +0800, Shawn Guo <shawn.guo@linaro.org> wrote:
>> > It fixes the issue in gpio-generic that commit fb14921 (gpio/mxc: add
>> > missing initialization of basic_mmio_gpio shadow variables) manged to
>> > fix in gpio-mxc driver, so that other platform specific drivers do not
>> > suffer from the same problem over and over again.
>> >
>> > Changes since v1:
>> > * Turn the last parameter "bool big_endian" into "unsigned long flags"
>> >   and give those really quirky hardwares a chance to tell that reg_set
>> >   and reg_dir are unreadable.
>> >
>> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>>
>> Applied, thanks.
>>
> Grant,
>
> Can you please pick up the RESEND version of the patch, which had
> bgpio_pdev_probe adapt bgpio_init parameter change too?

I did even though I replied to the original..  You can check my
gpio/next branch to be sure.

g.
