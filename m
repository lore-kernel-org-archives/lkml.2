Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab2EOMeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:34:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47857 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab2EOMd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:33:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120515112732.GB10347@shlinux2.ap.freescale.net>
References: <1337010369-28687-1-git-send-email-b29396@freescale.com>
	<CACRpkdbW8eeq0gFTjPRpKesmV4K5zqRHuW6C-UywBn8AtqOLCg@mail.gmail.com>
	<20120515112732.GB10347@shlinux2.ap.freescale.net>
Date: Tue, 15 May 2012 14:33:58 +0200
Message-ID: <CACRpkdaKAF8bznd-sBdcGfdJW_cHSUGFZhnVk4qJ_0LJ8GoUuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: add imx53 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 1:27 PM, Dong Aisheng
<aisheng.dong@freescale.com> wrote:
> On Tue, May 15, 2012 at 07:10:58PM +0800, Linus Walleij wrote:
>> Dong, will you merge the i.MX stuff through pinctrl or through
>> ARM SoC?
>
> This patch has no dependency on any arm soc stuffs.
> I think it's ok to go through pinctrl.

OK I'll be merging them, I was just thinking if you planned to also
make machine changes in this kernel cycle.

Yours,
Linus Walleij
