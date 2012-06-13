Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2FMIib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:38:31 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43814 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2FMIi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120612230630.GK19410@gmail.com>
References: <1339429196-32584-1-git-send-email-linus.walleij@linaro.org>
	<20120612230630.GK19410@gmail.com>
Date: Wed, 13 Jun 2012 10:38:26 +0200
Message-ID: <CACRpkdYvLEkuFLPCAT15jpqfML_tDwXuR6kENZbwMDaWpunrxQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] clk: add ICST307 driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 1:06 AM, Mike Turquette <mturquette@ti.com> wrote:
> On 20120611-17:39, Linus Walleij wrote:

>> +obj-$(CONFIG_CLK_ICST)               += clk-icst.o
>
> Is there a better place to put this than the top-level directory?

I can put it alone in a subdirectory if you want to... It is used only
by the ARM reference designs AFAICT, shall I put these Integrator
things into clk/versatile as we use the "versatile" name to refer to all
ARM reference designs (i.e. arch/arm/plat-versatile).

>> +struct clk * __init icst_clk_init(struct device *dev, const struct clk_icst_desc *desc)
>
> Nitpick: icst_clk_init should be renamed icst_clk_register to more
> closely resemble other clock registration functions which allocate
> memory dynamically.

I'll fix!

Yours,
Linus Walleij
