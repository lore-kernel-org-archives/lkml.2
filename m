Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0JHNxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:53:47 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:49562 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab0JHNxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:53:46 -0400
Message-ID: <19631.8795.122477.334402@ipc1.ka-ro>
Date: Fri, 8 Oct 2010 15:53:31 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: <Dinh.Nguyen@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de, bryan.wu@canonical.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        xiao-lizhang@freescale.com, valentin.longchamp@epfl.ch
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv6] ARM: imx: Add iram allocator functions
In-Reply-To: <1286545333-30323-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1286545333-30323-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dinh.Nguyen@freescale.com writes:
[...]
> +void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
> +{
> +	if (!iram_pool)
> +		return NULL;
> +
> +	*dma_addr = gen_pool_alloc(iram_pool, size);
> +	pr_debug("iram alloc - %dB@0x%p\n", size, (void *)*dma_addr);
                                                  ^^^^^^^^
Is there any reason to insist on this silly type cast instead of using
the format string that fits the data type?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
