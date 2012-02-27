Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab2B0H3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:29:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2B0H3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:29:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.179.8 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330074945.8642.1.camel@phoenix>
References: <1330074945.8642.1.camel@phoenix>
Date: Mon, 27 Feb 2012 08:29:37 +0100
Message-ID: <CACRpkdYiuS9CP1aPZnFYt08C2g4uHKinh4jL=7Jgn2serSCBqg@mail.gmail.com>
Subject: Re: [PATCH RFC] regulator: Convert ab8500 to use get_voltage_sel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:15 AM, Axel Lin <axel.lin@gmail.com> wrote:

> This change is required to make ab8500_regulator_get_voltage_sel work.
> The regulator core will call set_voltage_time_sel only when get_voltage_sel is
> implemented.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi,
> I don't have this hardware, I'd appreciate if someone can test this patch.

I've applied it and booted and it seems to work just fine, nice refactoring
there Axel!

Tested-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
