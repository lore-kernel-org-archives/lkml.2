Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344Ab2DLRfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:35:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62321 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760325Ab2DLRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120412170924.GA18049@opensource.wolfsonmicro.com>
References: <1334133248-1452-1-git-send-email-linus.walleij@stericsson.com>
	<20120412170924.GA18049@opensource.wolfsonmicro.com>
Date: Thu, 12 Apr 2012 19:34:59 +0200
Message-ID: <CACRpkdb8suiq=eu26JB==AscfdgJB7QKyxTn_1m=6Bngp8P5Eg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: implement pinctrl deferred probing
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 7:09 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks!

> Note that the probe deferral code already has info level logs every time
> it does anything so you'll probably have a hint from that when it kicks
> into action.

Yeah, but these messages tell you what caused the deferral.
I'll take some patches the day someone thinks the kernel is
getting too talkative...

Yours,
Linus Walleij
