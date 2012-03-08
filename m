Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2CHI7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:59:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2CHI7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 03:59:45 -0500
MIME-Version: 1.0
In-Reply-To: <20120308074149.GA18510@pengutronix.de>
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
	<20120307173157.GT3107@opensource.wolfsonmicro.com>
	<CACRpkdaEHOGA2XfW1SMJodyf9oTNRF7kk9ErQeSpBv_2TFj=Rg@mail.gmail.com>
	<20120308074149.GA18510@pengutronix.de>
Date: Thu, 8 Mar 2012 09:59:44 +0100
Message-ID: <CACRpkdboqxom1MbjfqMC=zYYL-aZL7sciWkqMaxVSDWXyFu5nw@mail.gmail.com>
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 8:41 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:

>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> I'd ask Grant to take this into the GPIO tree if Broonie can ACK it.
>
> Uhm, why? What's wrong with going in via I2C?

So it can be merged without bisect regressions for this merge
window, Laxman seems to prefer that it get in now.

If it doesn't get merged until v3.5, no issue.

Yours,
Linus Walleij
