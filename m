Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0JCMmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 08:42:51 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:6474 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0JCMmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 08:42:49 -0400
Message-ID: <4CA87A47.6030007@bfs.de>
Date: Sun, 03 Oct 2010 14:42:47 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH v3 11/20] Staging: rtl8192su: Makefile: cleaned up Makefile
 cflag lines
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com> <1286037489-28439-11-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1286037489-28439-11-git-send-email-tdent48227@gmail.com>
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
>  drivers/staging/rtl8192su/Makefile |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192su/Makefile b/drivers/staging/rtl8192su/Makefile
> index 7133894..1120c04 100644
> --- a/drivers/staging/rtl8192su/Makefile
> +++ b/drivers/staging/rtl8192su/Makefile
> @@ -1,12 +1,12 @@
>  NIC_SELECT = RTL8192SU
>  
> -EXTRA_CFLAGS += -std=gnu89
> -EXTRA_CFLAGS += -O2
> +ccflags-y := -std=gnu89
> +ccflags-y += -O2
>  


I still do not think that -O2 belongs here.
it should simply be removed.

re,
 wh



> -EXTRA_CFLAGS += -DJACKSON_NEW_RX
> -EXTRA_CFLAGS += -DTHOMAS_BEACON
> +ccflags-y += -DJACKSON_NEW_RX
> +ccflags-y += -DTHOMAS_BEACON
>  
> -#EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
> +#ccflags-y += -DMUTIPLE_BULK_OUT
>  
>  r8192s_usb-objs :=		\
>  	r8192U_wx.o		\
