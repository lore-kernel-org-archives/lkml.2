Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0JCNJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:09:40 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:15918 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab0JCNJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:09:39 -0400
Message-ID: <4CA88090.2030100@bfs.de>
Date: Sun, 03 Oct 2010 15:09:36 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH v3 18/20] Staging: vt6656: Makefile: cleaned up Makefile
 cflag lines
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com> <1286037489-28439-18-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1286037489-28439-18-git-send-email-tdent48227@gmail.com>
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
>  drivers/staging/vt6656/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
> index 582a35197..41ed06b 100644
> --- a/drivers/staging/vt6656/Makefile
> +++ b/drivers/staging/vt6656/Makefile
> @@ -1,6 +1,6 @@
>  # TODO: all of these should be removed
> -EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DEXPORT_SYMTAB -D__NO_VERSION__
> -EXTRA_CFLAGS += -DHOSTAP
> +ccflags-y := -DLINUX -D__KERNEL__ -DEXPORT_SYMTAB -D__NO_VERSION__
> +ccflags-y += -DHOSTAP
>  
>  vt6656_stage-y +=	main_usb.o \
>  			card.o  \


I am wondering what will happen when we remove -DLINUX will it think we are _DOS_ ?
re,
 wh
