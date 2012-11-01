Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2KAJMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:12:51 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:39791 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2KAJMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:12:47 -0400
Date: Thu, 1 Nov 2012 10:12:33 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: plat-versatile: move FPGA irq driver to
 drivers/irqchip
Message-ID: <20121101101233.17ffcf5a@skate>
In-Reply-To: <CACRpkda06BbFOiX1WSqNLM-R5Es-Nd6btUNq2mMDuH7s3jA2cw@mail.gmail.com>
References: <1351719113-30880-1-git-send-email-linus.walleij@linaro.org>
	<5091CA18.7020905@gmail.com>
	<CACRpkda06BbFOiX1WSqNLM-R5Es-Nd6btUNq2mMDuH7s3jA2cw@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Thu, 1 Nov 2012 10:00:19 +0100, Linus Walleij wrote:

> Sounds like a separate patch but surely we can do this. Is Thomas'
> stuff on a branch somewhere that I can then rebase upon to get
> it upstream? I was planning to get this series as such to the
> ARM SoC maintainers soon-ish.

Not at the moment. But do you want me to put that in a branch, and
agglomerate all the related patches (posted by Rob for GIC/VIC and by
you for the FPGA IRQ controller), and then later send a pull request to
Arnd with those changes?

Also, again, the whole point of the initial infrastructure in
drivers/irqchip/ was to avoid adding per-driver header files in
include/linux/irqchip/, so there should at least be a long term plan on
how to remove those headers file, either by moving more platforms to
DT, or my extending the irqchip infrastructure to cover more features.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
