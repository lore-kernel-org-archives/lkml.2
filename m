Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2DRVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:09:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48491 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2DRVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:09:25 -0400
Message-ID: <4F8F2D7F.8090905@lwfinger.net>
Date: Wed, 18 Apr 2012 16:09:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 11/12] drivers: staging: rtl8172: Remove unneeded include
 of version.h
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com> <1334723412-5034-12-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1334723412-5034-12-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 11:30 PM, Marcos Paulo de Souza wrote:
> The output of "make versioncheck" told us that:
>
> drivers/staging/rtl8712/osdep_service.h: 32 linux/version.h not needed.
> drivers/staging/rtl8712/rtl871x_ioctl_linux.c: 46 linux/version.h not needed.
>
> If we take a look at these files, we will agree to remove it.
>
> Cc: Larry Finger<Larry.Finger@lwfinger.net>
> Cc: Florian Schilhabel<florian.c.schilhabel@googlemail.com>
> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> Cc:<devel@driverdev.osuosl.org>
> Signed-off-by: Marcos Paulo de Souza<marcos.souza.org@gmail.com>
> ---
>   drivers/staging/rtl8712/osdep_service.h       |    1 -
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 -
>   2 files changed, 0 insertions(+), 2 deletions(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>


>
> diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
> index 9ba6033..cabf774 100644
> --- a/drivers/staging/rtl8712/osdep_service.h
> +++ b/drivers/staging/rtl8712/osdep_service.h
> @@ -29,7 +29,6 @@
>   #define _SUCCESS	1
>   #define _FAIL		0
>
> -#include<linux/version.h>
>   #include<linux/spinlock.h>
>
>   #include<linux/interrupt.h>
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index ef35bc2..a44d539 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -43,7 +43,6 @@
>   #include<linux/module.h>
>   #include<linux/kernel.h>
>   #include<linux/init.h>
> -#include<linux/version.h>
>   #include<linux/io.h>
>   #include<linux/semaphore.h>
>   #include<net/iw_handler.h>

