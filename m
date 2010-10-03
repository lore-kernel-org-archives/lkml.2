Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0JCMsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 08:48:40 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:6644 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0JCMsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 08:48:39 -0400
Message-ID: <4CA87BA5.2070305@bfs.de>
Date: Sun, 03 Oct 2010 14:48:37 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH v3 12/20] Staging: rtl8192su: ieee80211: Makefile: cleaned
 up Makefile cflag lines
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com> <1286037489-28439-12-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1286037489-28439-12-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tracey Dent schrieb:
> Changed to use the proper ccflags-y option
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/rtl8192su/ieee80211/Makefile |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192su/ieee80211/Makefile b/drivers/staging/rtl8192su/ieee80211/Makefile
> index a500bfa..5bee643 100644
> --- a/drivers/staging/rtl8192su/ieee80211/Makefile
> +++ b/drivers/staging/rtl8192su/ieee80211/Makefile
> @@ -1,10 +1,10 @@
>  NIC_SELECT = RTL8192SU
>  
> -EXTRA_CFLAGS += -O2
> -EXTRA_CFLAGS += -DRTL8192S_DISABLE_FW_DM=0
> -EXTRA_CFLAGS += -DRTL8192SU
> -#EXTRA_CFLAGS += -DJOHN_NOCPY
> -EXTRA_CFLAGS += -DTHOMAS_TURBO
> +ccflags-y := -O2

optimisation should be configured in the main file.

re,
 wh

> +ccflags-y += -DRTL8192S_DISABLE_FW_DM=0
> +ccflags-y += -DRTL8192SU
> +#ccflags-y += -DJOHN_NOCPY
> +ccflags-y += -DTHOMAS_TURBO
>  
>  ieee80211-rsl-objs := ieee80211_rx.o \
>  		      ieee80211_softmac.o \
