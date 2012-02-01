Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2BARes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:34:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45664 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2BARer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:34:47 -0500
Date: Wed, 1 Feb 2012 21:34:41 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@nsc.com>
Subject: Re: [PATCH] power_supply: lp8727_charger: Add terminating entry for
 i2c_device_id table
Message-ID: <20120201173441.GB9311@oksana.dev.rtsoft.ru>
References: <1326692900.12796.0.camel@phoenix>
 <B567DBAB974C0544994013492B949F8E3812BEF09C@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812BEF09C@EXMAIL03.scwf.nsc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 04:33:43PM -0800, Kim, Milo wrote:
> Thanks,
> 
> I think Anton will apply this patch.
> 
> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com] 
> Sent: Monday, January 16, 2012 2:48 PM
> To: linux-kernel@vger.kernel.org
> Cc: Kim, Milo; Jeong, Daniel; Anton Vorontsov
> Subject: [PATCH] power_supply: lp8727_charger: Add terminating entry for i2c_device_id table
> 
> The i2c_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Applied to battery-urgent.git, thanks!

> ---
>  drivers/power/lp8727_charger.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> index b15b575..c53dd12 100644
> --- a/drivers/power/lp8727_charger.c
> +++ b/drivers/power/lp8727_charger.c
> @@ -464,6 +464,7 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
>  
>  static const struct i2c_device_id lp8727_ids[] = {
>  	{"lp8727", 0},
> +	{ }
>  };
>  
>  static struct i2c_driver lp8727_driver = {
> -- 
> 1.7.5.4

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
