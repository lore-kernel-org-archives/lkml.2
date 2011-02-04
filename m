Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1BDUep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:34:45 -0500
Received: from bay0-omc1-s20.bay0.hotmail.com ([65.54.190.31]:17091 "EHLO
	bay0-omc1-s20.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab1BDUeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:34:44 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Feb 2011 15:34:44 EST
Message-ID: <4D4C6168.8010405@studio.unibo.it>
Date: Fri, 4 Feb 2011 21:28:24 +0100
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: <luca.risolia@studio.unibo.it>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: <linux-kernel@vger.kernel.org>, <security@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 07/20] video: sn9c102: world-wirtable sysfs files
References: <cover.1296818921.git.segoon@openwall.com> <b560d7c146330b382b90d739a76d580ed4051d4e.1296818921.git.segoon@openwall.com>
In-Reply-To: <b560d7c146330b382b90d739a76d580ed4051d4e.1296818921.git.segoon@openwall.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-MS-Exchange-Transport-Rules-Loop: 0
X-OriginalArrivalTime: 04 Feb 2011 20:28:34.0649 (UTC) FILETIME=[189B0C90:01CBC4AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Luca Risolia <luca.risolia@studio.unibo.it>

Vasiliy Kulikov ha scritto:
> Don't allow everybody to change video settings.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested only.
> 
>  drivers/media/video/sn9c102/sn9c102_core.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
> index 84984f6..ce56a1c 100644
> --- a/drivers/media/video/sn9c102/sn9c102_core.c
> +++ b/drivers/media/video/sn9c102/sn9c102_core.c
> @@ -1430,9 +1430,9 @@ static DEVICE_ATTR(i2c_reg, S_IRUGO | S_IWUSR,
>  		   sn9c102_show_i2c_reg, sn9c102_store_i2c_reg);
>  static DEVICE_ATTR(i2c_val, S_IRUGO | S_IWUSR,
>  		   sn9c102_show_i2c_val, sn9c102_store_i2c_val);
> -static DEVICE_ATTR(green, S_IWUGO, NULL, sn9c102_store_green);
> -static DEVICE_ATTR(blue, S_IWUGO, NULL, sn9c102_store_blue);
> -static DEVICE_ATTR(red, S_IWUGO, NULL, sn9c102_store_red);
> +static DEVICE_ATTR(green, S_IWUSR, NULL, sn9c102_store_green);
> +static DEVICE_ATTR(blue, S_IWUSR, NULL, sn9c102_store_blue);
> +static DEVICE_ATTR(red, S_IWUSR, NULL, sn9c102_store_red);
>  static DEVICE_ATTR(frame_header, S_IRUGO, sn9c102_show_frame_header, NULL);
>  
>  
