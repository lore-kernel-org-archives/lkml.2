Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2JQVU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:20:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51835 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab2JQVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:20:55 -0400
Date: Wed, 17 Oct 2012 14:20:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nitin Dhingra <nitin.dhingra@stericsson.com>
Cc: devel@driverdev.osuosl.org, Anurag GUPTA-1 <anurag.gupta@stericsson.com>,
        Ingvar PALSSON <ingvar.palsson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar HJALMDAHL <par-gunnar.hjalmdahl@stericsson.com>,
        linux-kernel@vger.kernel.org, Mridul Jain <mridul.jain@stericsson.com>
Subject: Re: [PATCH] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20121017212051.GA30879@kroah.com>
References: <1348733648-13769-1-git-send-email-nitin.dhingra@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348733648-13769-1-git-send-email-nitin.dhingra@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:14:08AM -0700, Nitin Dhingra wrote:
> This patch adds support for the ST-Ericsson CG2900
> Connectivity Combo controller (Bluetooth, FM, GPS, ANT, NFC)
> 
> Signed-off-by: Nitin Dhingra <nitin.dhingra@stericsson.com>
> Signed-off-by: Mridul Jain <mridul.jain@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  arch/arm/configs/u8500_defconfig                 |    8 +
>  drivers/staging/Kconfig                          |    2 +
>  drivers/staging/Makefile                         |    1 +
>  drivers/staging/cg2900/Kconfig                   |   73 +
>  drivers/staging/cg2900/Makefile                  |   10 +
>  drivers/staging/cg2900/bluetooth/Makefile        |    9 +
>  drivers/staging/cg2900/bluetooth/btcg2900.c      |  865 +++++
>  drivers/staging/cg2900/bluetooth/cg2900_uart.c   | 2434 +++++++++++++
>  drivers/staging/cg2900/bluetooth/hci_ldisc.c     |  645 ++++
>  drivers/staging/cg2900/bluetooth/hci_uart.h      |  106 +
>  drivers/staging/cg2900/include/cg2900.h          |  338 ++
>  drivers/staging/cg2900/include/cg2900_audio.h    |  473 +++
>  drivers/staging/cg2900/include/cg2900_hci.h      |   19 +
>  drivers/staging/cg2900/mfd/Makefile              |   18 +
>  drivers/staging/cg2900/mfd/cg2900_audio.c        | 3533 +++++++++++++++++++
>  drivers/staging/cg2900/mfd/cg2900_char_devices.c |  802 +++++
>  drivers/staging/cg2900/mfd/cg2900_chip.c         | 3986 ++++++++++++++++++++++
>  drivers/staging/cg2900/mfd/cg2900_chip.h         |  608 ++++
>  drivers/staging/cg2900/mfd/cg2900_core.c         |  730 ++++
>  drivers/staging/cg2900/mfd/cg2900_core.h         |   52 +
>  drivers/staging/cg2900/mfd/cg2900_lib.c          |  287 ++
>  drivers/staging/cg2900/mfd/cg2900_lib.h          |   65 +
>  drivers/staging/cg2900/mfd/cg2900_test.c         |  402 +++
>  drivers/staging/cg2900/mfd/stlc2690_chip.c       | 1710 ++++++++++
>  drivers/staging/cg2900/mfd/stlc2690_chip.h       |   47 +
>  25 files changed, 17223 insertions(+), 0 deletions(-)

Please refresh my memory, why is this going into drivers/staging/ and
not into the "real" part of the kernel?

Hint, a TODO file listing what is needed to do to get the code merged
properly is needed here, care to make a follow-on patch adding this
which will explain what to do.

thanks,

greg k-h
