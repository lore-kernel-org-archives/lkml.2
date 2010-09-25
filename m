Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0IYKpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:45:04 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:31018 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0IYKpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:45:01 -0400
Message-ID: <4C9DD2A4.6080508@bfs.de>
Date: Sat, 25 Sep 2010 12:44:52 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: greg@kroah.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/22] Staging: rtl8187se: Makefile: cleaned up makefile
 cflag lines
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com> <1285370890-8984-11-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1285370890-8984-11-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tracey Dent schrieb:
> Changed to use proper ccflags-y option
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/rtl8187se/Makefile |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
> index e6adf91..51fbd24 100644
> --- a/drivers/staging/rtl8187se/Makefile
> +++ b/drivers/staging/rtl8187se/Makefile
> @@ -1,20 +1,20 @@
>  
> -#EXTRA_CFLAGS += -DCONFIG_IEEE80211_NOWEP=y
> -#EXTRA_CFLAGS += -std=gnu89
> -#EXTRA_CFLAGS += -O2
> +#ccflags-y := -DCONFIG_IEEE80211_NOWEP=y
> +#ccflags-y := -std=gnu89
> +#ccflags-y := -O2
>  #CC            = gcc
>  
> -EXTRA_CFLAGS += -DSW_ANTE
> -EXTRA_CFLAGS += -DTX_TRACK
> -EXTRA_CFLAGS += -DHIGH_POWER
> -EXTRA_CFLAGS += -DSW_DIG
> -EXTRA_CFLAGS += -DRATE_ADAPT
> +ccflags-y := -DSW_ANTE
> +ccflags-y := -DTX_TRACK
> +ccflags-y := -DHIGH_POWER
> +ccflags-y := -DSW_DIG
> +ccflags-y := -DRATE_ADAPT
>  
>  #enable it for legacy power save, disable it for leisure  power save
> -EXTRA_CFLAGS += -DENABLE_LPS
> +ccflags-y := -DENABLE_LPS
>  
>  
> -#EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
> +#ccflags-y := -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
>  

I do not understand this. If CONFIG_FORCE_HARD_FLOAT is required by the
driver so he should fail if CONFIG_FORCE_HARD_FLOAT=n
Or you need to protect the -mhard-float with an if().

re,
 wh

