Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1GDJAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:00:08 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34777 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066Ab1GDJAE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <1309541802-5975-1-git-send-email-khilman@ti.com>
References: <1309541802-5975-1-git-send-email-khilman@ti.com>
Date: Mon, 4 Jul 2011 14:30:02 +0530
Message-ID: <CANfBPZ9XiHomYEmnf_xobtVvOs=PpGLnifAkn6wDFquBR+8QHQ@mail.gmail.com>
Subject: Re: [PATCH] MMC: OMAP: change HSMMC maintainence to Orphan
From: "S, Venkatraman" <svenkatr@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Madhusudhan Chikkature <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 11:06 PM, Kevin Hilman <khilman@ti.com> wrote:
> From: Madhusudhan Chikkature <madhu.cr@ti.com>
>
> Update the OMAP HS MMC entry from the MAINTAINERS file as I will
> no longer be able to maintain this driver.
>
> Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
> [khilman@ti.com: change to Orphan rather than complete removal]
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
> Applies to v3.0-rc5
>
>  MAINTAINERS |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f0358cd..2f238b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4574,9 +4574,8 @@ S:        Maintained
>  F:     drivers/mmc/host/omap.c
>
>  OMAP HS MMC SUPPORT
> -M:     Madhusudhan Chikkature <madhu.cr@ti.com>
>  L:     linux-omap@vger.kernel.org
> -S:     Maintained
> +S:     Orphan
>  F:     drivers/mmc/host/omap_hsmmc.c
>
>  OMAP RANDOM NUMBER GENERATOR SUPPORT
> --
> 1.7.6
>
Note for the record:
I am interested in making sure that this driver is well supported, even if
not designated as 'official' maintainer due to other commitments (as of now).
Patches are welcome.

Acked-by: Venkatraman S <svenkatr@ti.com>
