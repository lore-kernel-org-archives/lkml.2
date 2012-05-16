Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190Ab2EPHuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:50:01 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43341 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2EPHuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:50:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120516074530.GE10347@shlinux2.ap.freescale.net>
References: <1337068143-15579-1-git-send-email-b29396@freescale.com>
	<20120516074530.GE10347@shlinux2.ap.freescale.net>
Date: Wed, 16 May 2012 09:49:59 +0200
Message-ID: <CACRpkdY4b9AX5ZcqwuEoquFTGNbLGH=R=vZ5js63r2g4V63EEg@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: add imx53 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 9:45 AM, Dong Aisheng
<aisheng.dong@freescale.com> wrote:
> Hi Linus,
>
> On Tue, May 15, 2012 at 03:49:02PM +0800, Dong Aisheng-B29396 wrote:
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>> ---
>> ChangeLog v1->v2:
>> * change PIN_FUNC_ID base in binding doc to 0 from 1.
> I just checked your tree and it seems you merged the v1 series.
> Can you merge this v2 instead?

Aha sorry. Fixing it up now... check in some 30 mins or so.

Linus Walleij
