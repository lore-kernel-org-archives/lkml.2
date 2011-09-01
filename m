Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab1IAMGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:06:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44574 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IAMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:06:14 -0400
MIME-Version: 1.0
In-Reply-To: <1313137619-30580-1-git-send-email-linus.walleij@stericsson.com>
References: <1313137619-30580-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 1 Sep 2011 14:06:13 +0200
Message-ID: <CACRpkdbEGAFSfj1-vvzZxmjKVS78qFM7unwwJBA8rZ0zNCV0UQ@mail.gmail.com>
Subject: Re: [PATCH 00/23] mfd: DBx500 PRCMU updates
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Pawel Szyszuk <pawel.szyszuk@stericsson.com>,
        Jimmy Rubin <jimmy.rubin@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 10:26 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> The following patchset refactors and updates the MFD PRCMU
> (Power Reset Control Management Unit) drivers for DBx500.

Sam are these OK? They would benefit from some rotation in
linux-next and I have dependent changes to CPUfreq drivers that
will be dependent on this patch set too... so it'd be great if you
could have a look.

Thanks,
Linus Walleij
