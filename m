Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab2KAJAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:00:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42177 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab2KAJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:00:20 -0400
MIME-Version: 1.0
In-Reply-To: <5091CA18.7020905@gmail.com>
References: <1351719113-30880-1-git-send-email-linus.walleij@linaro.org>
	<5091CA18.7020905@gmail.com>
Date: Thu, 1 Nov 2012 10:00:19 +0100
Message-ID: <CACRpkda06BbFOiX1WSqNLM-R5Es-Nd6btUNq2mMDuH7s3jA2cw@mail.gmail.com>
Subject: Re: [PATCH] ARM: plat-versatile: move FPGA irq driver to drivers/irqchip
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 2:02 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 10/31/2012 04:31 PM, Linus Walleij wrote:

>>  rename arch/arm/plat-versatile/include/plat/fpga-irq.h => include/linux/platform_data/irq-versatile-fpga.h (100%)
>
> I think include/linux/irqchip/ is the right place.

OK I'll fix.

> Ideally we would not
> need the header at all. You can remove some of the function declarations
> if you base this on Thomas Petazzoni's series to have a common init
> function for DT and also move the fpga_handle_irq init into the
> fpga_irq_init function.

Sounds like a separate patch but surely we can do this. Is Thomas'
stuff on a branch somewhere that I can then rebase upon to get
it upstream? I was planning to get this series as such to the
ARM SoC maintainers soon-ish.

Yours,
Linus Walleij
