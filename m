Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab2CTMBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:01:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61351 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774Ab2CTMBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <1332208268.10843.1.camel@phoenix>
References: <1332208268.10843.1.camel@phoenix>
Date: Tue, 20 Mar 2012 13:00:59 +0100
Message-ID: <CACRpkdayrqk40OkQMOfwm43NOE4GWYBNb1QxJJvuCuwPiPp1pA@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: Convert ab8500 to set_voltage_sel
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

On Tue, Mar 20, 2012 at 2:51 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Convert ab8500 to set_voltage_sel and then we can remove
> ab8500_get_best_voltage_index function.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Tested on the U8500, works like a charm AFAICT.
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel!
Linus Walleij
