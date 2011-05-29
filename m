Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1E2RAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 13:00:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35421 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1E2RAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 13:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s1SNCTLNqYq5xDidQdsHTF+unNkWAg4a+Ik1JR6SpUMVjy6baOY6pzW7/zzftvHdvQ
         z1xN+AxR3Ci/+arB7NqasBog57rdcEa3UdEt/zzQytVM1r49F3YlDwa+D3RrqiDEw1SI
         q+VlwlfW0HtbAeY1ZFNCJCAr8FBJVvm7rnraM=
MIME-Version: 1.0
In-Reply-To: <a605f8a8039f83fae3fbf61b58f846bc3c58c379.1306342673.git.joe@perches.com>
References: <cover.1306342673.git.joe@perches.com>
	<BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
	<a605f8a8039f83fae3fbf61b58f846bc3c58c379.1306342673.git.joe@perches.com>
Date: Sun, 29 May 2011 18:00:33 +0100
Message-ID: <BANLkTimY9-ng8HVm+QFyS8FYks_mFx=ong@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: Remove direct includes of printk.h
From: julie Sullivan <kernelmail.jms@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        Dowan Kim <dowan@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> +++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> @@ -16,7 +16,6 @@
>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
> -#include <linux/printk.h>


> --- a/drivers/staging/usbip/usbip_common.h
> +++ b/drivers/staging/usbip/usbip_common.h
> @@ -24,7 +24,7 @@
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
>  #include <linux/net.h>
> -#include <linux/printk.h>
> +#include <linux/kernel.h>
>  #include <linux/spinlock.h>
>  #include <linux/types.h>

types.h is also a subfile of kernel.h, right?
Or maybe you patched this one already - if so please excuse the noise :-)

Cheers
Julie
