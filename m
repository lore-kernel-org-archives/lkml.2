Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1GMP1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:27:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34604 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab1GMP1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <1310564781-5979-1-git-send-email-monstr@monstr.eu>
References: <1310564781-5979-1-git-send-email-monstr@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 14 Jul 2011 00:27:12 +0900
X-Google-Sender-Auth: YdrvG9KRVJAX8Dm9OC0Odv6gGzs
Message-ID: <CACxGe6vRZ4tCALpzFng2y9W_9zB3qQEntma+z292FXzDuYBRKQ@mail.gmail.com>
Subject: Re: [PATCH] input: xilinx_ps2: Add missing of_address.h header
To: Michal Simek <monstr@monstr.eu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 10:46 PM, Michal Simek <monstr@monstr.eu> wrote:
> Add missing header.
>
> Error log:
> CC      drivers/input/serio/xilinx_ps2.o
> drivers/input/serio/xilinx_ps2.c: In function 'xps2_of_probe':
> drivers/input/serio/xilinx_ps2.c:249: error: implicit declaration of function 'of_address_to_resource'
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/input/serio/xilinx_ps2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
> index 80baa53..d64c5a4 100644
> --- a/drivers/input/serio/xilinx_ps2.c
> +++ b/drivers/input/serio/xilinx_ps2.c
> @@ -23,7 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/io.h>
> -
> +#include <linux/of_address.h>
>  #include <linux/of_device.h>
>  #include <linux/of_platform.h>
>
> --
> 1.5.5.6
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
