Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2IRMLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:11:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52777 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab2IRMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <1347902538-21208-3-git-send-email-mporter@ti.com>
References: <1347902538-21208-1-git-send-email-mporter@ti.com>
	<1347902538-21208-3-git-send-email-mporter@ti.com>
Date: Tue, 18 Sep 2012 14:11:32 +0200
Message-ID: <CACRpkdagKxUD2QUYLJxh_R6QjAU-jDXsG=8TxJS-Vs_k_8ir_Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: OMAP2+: Enable pinctrl dummy states
From: Linus Walleij <linus.walleij@linaro.org>
To: Matt Porter <mporter@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>, AnilKumar <anilkumar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 7:22 PM, Matt Porter <mporter@ti.com> wrote:

> Enable pinctrl dummy states for all OMAP platforms that don't
> populate DT. This allows drivers to be converted to pinctrl
> and not generate new warnings on platforms that do not provide
> pinctrl data. These platforms already have pinmuxes configured
> before the drivers probe.
>
> Signed-off-by: Matt Porter <mporter@ti.com>

Looks like a good idea, so FWIW:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
