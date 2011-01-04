Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1ADVdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:33:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1ADVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:33:14 -0500
Date: Tue, 4 Jan 2011 13:32:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: BruceChang@via.com.tw, linux-kernel@vger.kernel.org,
        BenjaminPan@viatech.com, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] MAINTAINERS: update entries affecting VIA Technologies
 (resent as plaintext with hopefully all broken formatting fixed; merry
 Christmas)
Message-Id: <20110104133256.004ff54e.akpm@linux-foundation.org>
In-Reply-To: <4D15045C.90909@gmx.de>
References: <88652C7DDEB86A45A61D4100C612CD731E8CFB@exchtp12.taipei.via.com.tw>
	<4D15045C.90909@gmx.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010 21:36:44 +0100
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> From: Bruce Chang <BruceChang@via.com.tw>
> Date: Fri, 17 Dec 2010 21:05:57 +0800
> Subject: [PATCH] MAINTAINERS: update entries affecting VIA Technologies
> 
> Since the original maintainer-Joseph Chan (josephchan@via.com.tw)
> doesn't handle the Linux driver for VIA now, I would like to request to
> update the maintainer for the SD/MMC CARD CONTROLLER DRIVER and VIA
> UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER before we find a better one.
> Thank you very much for help.
> 
> Sign-off by: Bruce Chang < brucechang@via.com.tw >
> 
> --- linux-b4-modified/MAINTAINERS       2010-12-16 09:24:48.000000000 +0800
> +++ linux-aftr-modified/MAINTAINERS     2010-12-17 16:50:00.793647029 +0800
> @@ -6384,13 +6384,12 @@
>   F:	drivers/i2c/busses/i2c-viapro.c
> 
>   VIA SD/MMC CARD CONTROLLER DRIVER
> -M:	Joseph Chan <JosephChan@via.com.tw>
> +M:	Bruce Chang <brucechang@via.com.tw>
>   M:	Harald Welte <HaraldWelte@viatech.com>
>   S:	Maintained
>   F:	drivers/mmc/host/via-sdmmc.c
> 
>   VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
> -M:	Joseph Chan <JosephChan@via.com.tw>
>   M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>   L:	linux-fbdev@vger.kernel.org
>   S:	Maintained

- the patch was still space-stuffed.

- Use "Signed-off-by:", not "Sign-off by:"

- please cc the relevant mailing list and maintainer (Geert) on patches

- As you (Florian) forwarded the patch, it should have included your
  Signed-off-by: as well.  I made that change to my copy of the patch.

