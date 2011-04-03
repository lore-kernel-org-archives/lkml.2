Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1DCQIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:08:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39347 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1DCQIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nPGm1cmUBV/tFieNq4MYRw1HXUspNd5y2+Vp+OeALv195GAXF3F9ea8lhtZ6QSx6Zv
         MS+X+fV0MKH5GG5Z+IIwAfc1VmCS8/qT7EX7ckyiLZ72jbymiwCH36JG8QQjrJJB85UF
         W/gYbBvNSKCAtVTEYTV8Ykgx0wnGW9O0I6Ya4=
MIME-Version: 1.0
In-Reply-To: <1301456241-2922-1-git-send-email-bookjovi@gmail.com>
References: <1301456241-2922-1-git-send-email-bookjovi@gmail.com>
Date: Mon, 4 Apr 2011 00:08:44 +0800
Message-ID: <BANLkTikz_phEe4otFfn0aYB6UKn1AzbvPA@mail.gmail.com>
Subject: Re: [PATCH] amba: update file header info correctly
From: Jovi Zhang <bookjovi@gmail.com>
To: bookjovi@gmail.com
Cc: Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:37 AM,  <bookjovi@gmail.com> wrote:
> From: Jovi Zhang <bookjovi@gmail.com>
>
> update file header info correctly after file location changed
>
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> ---
>  drivers/amba/bus.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 6d2bb25..52aad48 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -1,5 +1,5 @@
>  /*
> - *  linux/arch/arm/common/amba.c
> + *  linux/drivers/amba/bus.c
>  *
>  *  Copyright (C) 2003 Deep Blue Solutions Ltd, All Rights Reserved.
>  *
> --
> 1.7.2.3
>
>
remove this line is better, I will resend it.
