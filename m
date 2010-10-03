Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0JCMkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 08:40:08 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:61477 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0JCMkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 08:40:07 -0400
Message-ID: <4CA879A1.3070400@bfs.de>
Date: Sun, 03 Oct 2010 14:40:01 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH v3 01/20] Staging: cx25821: Makefile: cleaned up Makefile
 cflag lines
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
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
>  drivers/staging/cx25821/Makefile |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
> index d0eb16e..6448364 100644
> --- a/drivers/staging/cx25821/Makefile
> +++ b/drivers/staging/cx25821/Makefile
> @@ -7,7 +7,7 @@ cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
>  obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
>  obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
>  
> -EXTRA_CFLAGS += -Idrivers/media/video
> -EXTRA_CFLAGS += -Idrivers/media/common/tuners
> -EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
> -EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> +ccflags-y := -Idrivers/media/video
> +ccflags-y += -Idrivers/media/common/tuners
> +ccflags-y += -Idrivers/media/dvb/dvb-core
> +ccflags-y += -Idrivers/media/dvb/frontends

they have invented vpath for this, did they ?
note: I am not familiar with the linux makefile.

re,
 wh
