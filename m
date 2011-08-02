Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1HBJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:56:24 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:49076 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752208Ab1HBJ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:56:19 -0400
Date: Tue, 2 Aug 2011 10:56:04 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: fix compile failure in orion5x/dns323-setup.c
Message-ID: <20110802095604.GA22637@linux-mips.org>
References: <1312216934-29710-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312216934-29710-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 12:42:14PM -0400, Paul Gortmaker wrote:

> index a6eddae..c105556 100644
> --- a/arch/arm/mach-orion5x/dns323-setup.c
> +++ b/arch/arm/mach-orion5x/dns323-setup.c
> @@ -77,7 +77,7 @@ static int __init dns323_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>  	/*
>  	 * Check for devices with hard-wired IRQs.
>  	 */
> -	irq = orion5x_pci_map_irq(const dev, slot, pin);
> +	irq = orion5x_pci_map_irq(dev, slot, pin);

Very obviously correct ...

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
