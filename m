Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1KNUZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:25:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51103 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1KNUZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:25:37 -0500
MIME-Version: 1.0
In-Reply-To: <3530313B48D5704B86CF382E8866C7F9AE0F34D0B4@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <3530313B48D5704B86CF382E8866C7F9AE0F34D0B4@IRVEXCHCCR02.corp.ad.broadcom.com>
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Date: Mon, 14 Nov 2011 12:25:16 -0800
Message-ID: <CAA6KcBC6AgZJYZtCWcZ1aS6xACSOWy_8GVzq9sEr8Ozou8oT_A@mail.gmail.com>
Subject: Re: [PATCH] usb: noted broken URL link in usb.c description
To: Michael Lewis <miclewis@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fair point.  I should get around to fixing that.  Why don't we
hold-off on the patch and let me work on this for a couple of days?

Matt

On Mon, Nov 14, 2011 at 12:14 PM, Michael Lewis <miclewis@broadcom.com> wrote:
> From ca036284fdc2a6801fab566c2218307235518876 Mon Sep 17 00:00:00 2001
> From: Michael Lewis <miclewis@broadcom.com>
> Date: Mon, 14 Nov 2011 11:47:42 -0800
> Subject: [PATCH] usb: noted broken URL link in usb.c description
>
>
> Signed-off-by: Michael Lewis <miclewis@broadcom.com>
> ---
>  drivers/usb/storage/usb.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index aa84b3d..33cf6ad 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -28,7 +28,8 @@
>  * status of a command.
>  *
>  * Please see http://www.one-eyed-alien.net/~mdharm/linux-usb for more
> - * information about this driver.
> + * information about this driver. Note, URL link is dead and needs
> + * to be fixed.
>  *
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of the GNU General Public License as published by the
> --
> 1.7.1
>
>



-- 
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
