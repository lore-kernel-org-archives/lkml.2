Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1KRIhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:37:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38736 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1KRIhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:37:20 -0500
MIME-Version: 1.0
In-Reply-To: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 18 Nov 2011 16:36:57 +0800
Message-ID: <CAGsJ_4xTbT5tCB75wU5EssDACbCyk-mR5jBXp-FXnBcFkt8T9g@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] MAINTAINERS: update maintainers for
 blackfin arch and drivers.
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/16 Sonic Zhang <sonic.adi@gmail.com>:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Acked-by: Barry Song <21cnbao@gmail.com>

I know the situation. so ack. haha....

> ---
>  MAINTAINERS |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7f6bc29..86941ba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1481,6 +1481,7 @@ F:        fs/bfs/
>  F:     include/linux/bfs_fs.h
>
>  BLACKFIN ARCHITECTURE
> +M:     Bob Liu <lliubbo@kernel.org>
>  M:     Mike Frysinger <vapier@gentoo.org>
>  L:     uclinux-dist-devel@blackfin.uclinux.org
>  W:     http://blackfin.uclinux.org
> @@ -1494,14 +1495,12 @@ S:      Supported
>  F:     drivers/net/ethernet/adi/
>
>  BLACKFIN RTC DRIVER
> -M:     Mike Frysinger <vapier.adi@gmail.com>
>  L:     uclinux-dist-devel@blackfin.uclinux.org
>  W:     http://blackfin.uclinux.org
>  S:     Supported
>  F:     drivers/rtc/rtc-bfin.c
>
>  BLACKFIN SDH DRIVER
> -M:     Cliff Cai <cliff.cai@analog.com>
>  L:     uclinux-dist-devel@blackfin.uclinux.org
>  W:     http://blackfin.uclinux.org
>  S:     Supported
> @@ -1515,7 +1514,6 @@ S:        Supported
>  F:     drivers/tty/serial/bfin_5xx.c
>
>  BLACKFIN WATCHDOG DRIVER
> -M:     Mike Frysinger <vapier.adi@gmail.com>
>  L:     uclinux-dist-devel@blackfin.uclinux.org
>  W:     http://blackfin.uclinux.org
>  S:     Supported
> --
> 1.7.0.4
