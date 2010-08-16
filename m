Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0HPNLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:11:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0HPNLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:11:13 -0400
Date: Mon, 16 Aug 2010 15:10:11 +0200
From: Ernst Schwab <eschwab@online.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: spi-devel-general@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: spi.h: missing kernel-doc notation, please fix
Message-Id: <20100816151011.68e6c722.eschwab@online.de>
In-Reply-To: <20100815103156.37ae14cd.rdunlap@xenotime.net>
References: <20100815103156.37ae14cd.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:qgT16KF4P/E35/r9ME7fY9t4oroz4QmfbzN9ExOqd7A
 9ESz4Rkk+aaulLUQhGvFkZS8nMOO32GJhP3JbQoGvBnxUSW3jE
 /YdhB2OGXm39BvxwdMMfTeZ/N2uo2O6M5z8sbUztUxq4dP8SWL
 jsyy55YBf58dBpaq8ygvZu/dTS1R04xMsk8yQEsMtUEC3Rd1JP
 wuo4T8vMdBHA3pqnpun4+WVrnGHCR1pF80j8EyBEZs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added comments in kernel-doc notation for previously added struct fields.

Signed-off-by: Ernst Schwab <eschwab@online.de>
---
On Sun, 15 Aug 2010 10:31:56 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> This patch in mainline:
> 
> commit cf32b71e981ca63e8f349d8585ca2a3583b556e0
> Author: Ernst Schwab <eschwab@online.de>
> Date:   Mon Jun 28 17:49:29 2010 -0700
> 
>    spi/mmc_spi: SPI bus locking API, using mutex
> 
> adds some struct fields but does not add kernel-doc notation for them.
> Please add that missing struct documentation.

diff a/include/linux/spi/spi.h b/include/linux/spi/spi.h
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -213,6 +213,9 @@ static inline void spi_unregister_driver
  * @dma_alignment: SPI controller constraint on DMA buffers alignment.
  * @mode_bits: flags understood by this controller driver
  * @flags: other constraints relevant to this driver
+ * @bus_lock_spinlock: spinlock for SPI bus locking 
+ * @bus_lock_mutex: mutex for SPI bus locking 
+ * @bus_lock_flag: indicates that the SPI bus is locked for exclusive use
  * @setup: updates the device mode and clocking records used by a
  *	device's SPI controller; protocol code may call this.  This
  *	must fail if an unrecognized or unsupported mode is requested.
