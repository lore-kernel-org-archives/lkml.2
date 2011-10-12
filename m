Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1JLVdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:33:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1JLVdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:33:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Barry Song <Barry.Song@csr.com>
Subject: Re: [PATCH] PM: HIBERNATION: do not initialise statics and externals to 0 or NULL
Date: Wed, 12 Oct 2011 23:35:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        linux-pm@lists.linux-foundation.org, Barry Song <Baohua.Song@csr.com>,
        Borislav Petkov <bp@alien8.de>
References: <1318400958-21481-1-git-send-email-Barry.Song@csr.com>
In-Reply-To: <1318400958-21481-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110122335.44140.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 12, 2011, Barry Song wrote:
> From: Barry Song <Baohua.Song@csr.com>
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
>  This patch depends on Barry Song's
>  PM: HIBERNATION: add resume_wait param to support MMC-like devices as resume file;
>  http://www.spinics.net/lists/linux-mmc/msg10282.html
>  PM: HIBERNATION: add resume_delay kernel param;
>  http://www.spinics.net/lists/linux-mmc/msg10478.html
> 
>  kernel/power/hibernate.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index f73a00e..19d443b 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -30,14 +30,14 @@
>  #include "power.h"
>  
>  
> -static int nocompress = 0;
> -static int noresume = 0;
> -static int resume_wait = 0;
> -static int resume_delay = 0;
> +static int nocompress;
> +static int noresume;
> +static int resume_wait;
> +static int resume_delay;
>  static char resume_file[256] = CONFIG_PM_STD_PARTITION;
>  dev_t swsusp_resume_device;
>  sector_t swsusp_resume_block;
> -int in_suspend __nosavedata = 0;
> +int in_suspend __nosavedata;
>  
>  enum {
>  	HIBERNATION_INVALID,
> 

