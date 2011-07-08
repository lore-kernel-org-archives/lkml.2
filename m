Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1GHRGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:06:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38941 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1GHRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CD17@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CD17@dbde02.ent.ti.com>
Date: Fri, 8 Jul 2011 19:06:16 +0200
Message-ID: <CACRpkdYF6Z7CxhZVvuT8V+ENRd6K0q7=uhk93kOaOG-W3AvoTw@mail.gmail.com>
Subject: Re: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design plan
From: Linus Walleij <linus.walleij@linaro.org>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Dan <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 10:22 AM, Raju, Sundaram <sundaram@ti.com> wrote:

> I would like to follow the Freescale i.MX DMA driver model,
> where imx-dma.c in drivers/dma which implements all the
> dmaengine hooks, internally uses the APIs in dma-v1.c file in
> arch/arm/mach-imx. All APIs in dma-v1.c are also exported
> out for direct use by clients.
>(...)
> Let me know your thoughts.

Sounds like a plan, just do it.
I think Samsung are currently using the scheme to migrate to
dmaengine as well.

Thanks,
Linus Walleij
