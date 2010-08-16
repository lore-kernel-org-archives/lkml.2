Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0HPPgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:36:44 -0400
Received: from xenotime.net ([72.52.115.56]:39783 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751823Ab0HPPgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:36:43 -0400
Date: Mon, 16 Aug 2010 08:36:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ernst Schwab <eschwab@online.de>
Cc: spi-devel-general@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: spi.h: missing kernel-doc notation, please fix
Message-Id: <20100816083637.ca01e53e.rdunlap@xenotime.net>
In-Reply-To: <20100816151011.68e6c722.eschwab@online.de>
References: <20100815103156.37ae14cd.rdunlap@xenotime.net>
	<20100816151011.68e6c722.eschwab@online.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010 15:10:11 +0200 Ernst Schwab wrote:

> Added comments in kernel-doc notation for previously added struct fields.
> 
> Signed-off-by: Ernst Schwab <eschwab@online.de>

Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

> ---
> On Sun, 15 Aug 2010 10:31:56 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > This patch in mainline:
> > 
> > commit cf32b71e981ca63e8f349d8585ca2a3583b556e0
> > Author: Ernst Schwab <eschwab@online.de>
> > Date:   Mon Jun 28 17:49:29 2010 -0700
> > 
> >    spi/mmc_spi: SPI bus locking API, using mutex
> > 
> > adds some struct fields but does not add kernel-doc notation for them.
> > Please add that missing struct documentation.
> 
> diff a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -213,6 +213,9 @@ static inline void spi_unregister_driver
>   * @dma_alignment: SPI controller constraint on DMA buffers alignment.
>   * @mode_bits: flags understood by this controller driver
>   * @flags: other constraints relevant to this driver
> + * @bus_lock_spinlock: spinlock for SPI bus locking 
> + * @bus_lock_mutex: mutex for SPI bus locking 
> + * @bus_lock_flag: indicates that the SPI bus is locked for exclusive use
>   * @setup: updates the device mode and clocking records used by a
>   *	device's SPI controller; protocol code may call this.  This
>   *	must fail if an unrecognized or unsupported mode is requested.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
