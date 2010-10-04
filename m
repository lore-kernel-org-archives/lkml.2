Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0JDXQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:16:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab0JDXQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:16:29 -0400
Date: Mon, 4 Oct 2010 16:16:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20101004161600.8cdf4e0c.akpm@linux-foundation.org>
In-Reply-To: <4CA4E76E.1050602@gmail.com>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>
	<4CA4D61C.2010909@gmail.com>
	<4CA4E76E.1050602@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 21:39:26 +0200
"N.P.S." <napohybelskurwysynom2010@gmail.com> wrote:

> Here is a patch that removes duplicate includes introduced in -next and 
> -mmotm
> 
> --
> Zimny Lech
> 
>   arch/arm/mach-omap2/board-rx51-peripherals.c           |    1 -
>   arch/arm/mm/flush.c                                    |    1 -
>   arch/xtensa/include/asm/coprocessor.h                  |    1 -
>   drivers/mmc/host/ushc.c                                |    1 -
>   drivers/staging/ath6kl/os/linux/include/ar6000_drv.h   |    1 -
>   drivers/staging/batman-adv/soft-interface.c            |    1 -
>   drivers/staging/bcm/headers.h                          |    1 -
>   drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c       |    4 ----
>   drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h       |    1 -
>   drivers/staging/brcm80211/brcmfmac/wl_iw.c             |    4 ----
>   drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c     |    1 -
>   drivers/staging/rtl8712/drv_types.h                    |    1 -
>   drivers/staging/rtl8712/osdep_service.h                |    1 -
>   drivers/staging/westbridge/astoria/gadget/cyasgadget.h |    3 ---
>   sound/soc/fsl/mpc5200_dma.c                            |    1 -
>   15 files changed, 23 deletions(-)

Removal of duplicated includes is a somewhat dangerous thing.  If
someone else says "hey, there's a duplicated include" and then fixes
it, and if this patch removes the other include then whoops, we broke
the build.  This has happened before.

So I'd ask that you redo and resend this patch shortly after 2.6.36 is
released please, so I can get it into mainline quickly thus minimising
the opportunity for such breakage.

> Signed-off-by: N.P.S. <napohybelskurwysynom2010@gmail.com>

We prefer that signoffs have real names in them, please.
