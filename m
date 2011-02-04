Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1BDP3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:29:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:44263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1BDP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:29:19 -0500
Message-ID: <4D4C1B48.4040107@infradead.org>
Date: Fri, 04 Feb 2011 13:29:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, security@kernel.org,
        Luca Risolia <luca.risolia@studio.unibo.it>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 07/20] video: sn9c102: world-wirtable sysfs files
References: <cover.1296818921.git.segoon@openwall.com> <b560d7c146330b382b90d739a76d580ed4051d4e.1296818921.git.segoon@openwall.com>
In-Reply-To: <b560d7c146330b382b90d739a76d580ed4051d4e.1296818921.git.segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-02-2011 10:23, Vasiliy Kulikov escreveu:
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

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
