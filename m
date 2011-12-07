Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1LGJJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:09:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57408 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1LGJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:09:35 -0500
MIME-Version: 1.0
In-Reply-To: <65EE16ACC360FA4D99C96DC085B3F772345A0B@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-3-git-send-email-b29396@freescale.com>
	<20111206072326.GA3712@S2100-06.ap.freescale.net>
	<65EE16ACC360FA4D99C96DC085B3F772345A0B@039-SN1MPN1-002.039d.mgd.msft.net>
Date: Wed, 7 Dec 2011 10:09:34 +0100
Message-ID: <CACRpkdbVXkpVHqhP2SHV2fud66NYFj0mcAPyaqJoyUS-20to5Q@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] pinctrl: imx: add pinmux-imx6q support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        Guo Shawn-R65073 <r65073@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 8:23 AM, Dong Aisheng-B29396
<B29396@freescale.com> wrote:
>> From: Guo Shawn-R65073
>> As I do not see the device tree probing added in pinmux-imx-core.c, I
>> expect the patch has not got the chance to run on imx6, right?
>>
> Yes, I would add it if the pinctrl framework supports DT.

There are many levels of DT.

You can of course add DT-support for anything driver-specific, such
as init data for some registers, or anything else you would normally
pass in through platform data. So please just do that if imx6 already
has support for such things.

What we're discussing about right now on devicetree-discuss
is where to put the mapping tables etc that is currently registered
by the board, that has no obvious solution as there is some
disagreement on how to do that.

Linus Walleij
