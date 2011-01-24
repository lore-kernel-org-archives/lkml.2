Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1AXGjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 01:39:20 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:45189 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952Ab1AXGjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 01:39:19 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-4-git-send-email-ccross@android.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1295834493-5019-4-git-send-email-ccross@android.com>
Thread-Index: Acu7ayP+iZqxmpaIQ8CSWN8XCC0nXQAJZEhQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Mon, 24 Jan 2011 12:09:13 +0530
Message-ID: <f0f885ab9398a623d0761e728a5ee4df@mail.gmail.com>
Subject: RE: [PATCH v2 03/28] ARM: gic: Export irq chip functions
To: Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>, konkers@android.com,
        Gary King <gking@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin,
> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-
> arm-kernel-bounces@lists.infradead.org] On Behalf Of Colin Cross
> Sent: Monday, January 24, 2011 7:31 AM
> To: linux-tegra@vger.kernel.org
> Cc: Russell King; Linus Walleij; konkers@android.com; Gary King;
> Catalin Marinas; Abhijeet Dharmapurikar; linux-
> kernel@vger.kernel.org; Colin Cross; olof@lixom.net; linux-arm-
> kernel@lists.infradead.org
> Subject: [PATCH v2 03/28] ARM: gic: Export irq chip functions
>
> Some systems combine the GIC with an external interrupt controller.
> On these systems it may be necessary to update both the GIC
> registers
> and the external controller's registers to control IRQ behavior.
> Export the irq chip functions so that these systems can define a
> custom irq chip that calls into the GIC handlers.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
> v2: Updated on top of irq_data changes
>
>  arch/arm/common/gic.c               |   11 +++++------
>  arch/arm/include/asm/hardware/gic.h |   10 ++++++++++
>  2 files changed, 15 insertions(+), 6 deletions(-)
>
Instead of exporting the GIC library, I think we could add the
flexibility with slightly different approach.
Have few common arm patches mainly for PM.
Will post them shortly. Have a look at them.


Regards,
Santosh
