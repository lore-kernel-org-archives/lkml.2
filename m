Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab2F3Tri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 15:47:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41233 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2F3Trh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 15:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120626015551.GW4402@gmail.com>
References: <20120626015551.GW4402@gmail.com>
Date: Sat, 30 Jun 2012 21:47:35 +0200
Message-ID: <CACRpkdayZUcA13p8iTRXLb4BestbAQhNP+a1nesYkcDEGFs=WA@mail.gmail.com>
Subject: Re: linux-next: adding the common clk tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 3:55 AM, Mike Turquette <mturquette@ti.com> wrote:

> Would you please add the clk-next branch of the common clock tree to
> linux-next?
>
> git://git.linaro.org/people/mturquette/linux.git clk-next

So I don't see this being pulled into -next, is it just a slip,
I though the structure of the branch was agreed upon and all?

(I have patches in there, that's why I'm hammering.)

Yours,
Linus Walleij
