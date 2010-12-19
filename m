Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab0LSTQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 14:16:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37558 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932396Ab0LSTQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 14:16:51 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/52SQ1f2D5rYSSdlN9EULdexjnVkT3CkEGN1lkwA
	xgPc2FlvBHetb2
From: Peter Huewe <PeterHuewe@gmx.de>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] [ARM] Add missing include "asm/memory.h"
Date: Sun, 19 Dec 2010 20:16:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1292566109.21261.1.camel@mola>
In-Reply-To: <1292566109.21261.1.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012192016.49026.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 17 Dezember 2010, 07:08:29 schrieb Axel Lin:
> This patch fixes below build error by adding the missing asm/memory.h,
> which is needed for arch_is_coherent().
> 
> $ make pxa3xx_defconfig; make
>   CC      init/do_mounts_rd.o
> In file included from include/linux/list_bl.h:5,
>                  from include/linux/rculist_bl.h:7,
>                  from include/linux/dcache.h:7,
>                  from include/linux/fs.h:381,
>                  from init/do_mounts_rd.c:3:
> include/linux/bit_spinlock.h: In function 'bit_spin_unlock':
> include/linux/bit_spinlock.h:61: error: implicit declaration of function
> 'arch_is_coherent' make[1]: *** [init/do_mounts_rd.o] Error 1
> make: *** [init] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good - compiles fine on
arm (hackkit_defconfig and ep93xx_defconfig), 

Acked-by: Peter Huewe <peterhuewe@gmx.de>
