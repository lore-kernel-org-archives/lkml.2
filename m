Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1KPNMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:12:09 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38099 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756547Ab1KPNMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:12:07 -0500
Message-ID: <1321449126.16478.2.camel@Joe-Laptop>
Subject: Re: [PATCH] MAINTAINERS: update maintainers for blackfin arch and
 drivers.
From: Joe Perches <joe@perches.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Date: Wed, 16 Nov 2011 05:12:06 -0800
In-Reply-To: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 15:48 +0800, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  MAINTAINERS |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7f6bc29..86941ba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1481,6 +1481,7 @@ F:	fs/bfs/
>  F:	include/linux/bfs_fs.h
>  
>  BLACKFIN ARCHITECTURE
> +M:	Bob Liu <lliubbo@kernel.org>
>  M:	Mike Frysinger <vapier@gentoo.org>
>  L:	uclinux-dist-devel@blackfin.uclinux.org
>  W:	http://blackfin.uclinux.org
> @@ -1494,14 +1495,12 @@ S:	Supported
>  F:	drivers/net/ethernet/adi/
>  
>  BLACKFIN RTC DRIVER
> -M:	Mike Frysinger <vapier.adi@gmail.com>
>  L:	uclinux-dist-devel@blackfin.uclinux.org
>  W:	http://blackfin.uclinux.org
>  S:	Supported
>  F:	drivers/rtc/rtc-bfin.c
>  
>  BLACKFIN SDH DRIVER
> -M:	Cliff Cai <cliff.cai@analog.com>
>  L:	uclinux-dist-devel@blackfin.uclinux.org
>  W:	http://blackfin.uclinux.org
>  S:	Supported
> @@ -1515,7 +1514,6 @@ S:	Supported
>  F:	drivers/tty/serial/bfin_5xx.c
>  
>  BLACKFIN WATCHDOG DRIVER
> -M:	Mike Frysinger <vapier.adi@gmail.com>
>  L:	uclinux-dist-devel@blackfin.uclinux.org
>  W:	http://blackfin.uclinux.org
>  S:	Supported

Drivers or arches without specific people to maintain
them really should not have "S: Supported".
These should really be "S: Orphan".


