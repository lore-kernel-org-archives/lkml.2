Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1CAUPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:15:05 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:52046 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756285Ab1CAUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:15:03 -0500
Message-ID: <4D6D53C5.7020906@bluewatersys.com>
Date: Wed, 02 Mar 2011 09:15:01 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 2/3] power: ds2782_battery: add MODULE_DEVICE_TABLE
References: <1298971353.17825.1.camel@mola> <1298971414.17825.2.camel@mola>
In-Reply-To: <1298971414.17825.2.camel@mola>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 10:23 PM, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> After adding the MODULE_DEVICE_TABLE, below entries will be added to
> modules.alias:
> alias i2c:ds2786 ds2782_battery
> alias i2c:ds2782 ds2782_battery
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks Axel,

Acked-by: Ryan Mallon <ryan@bluewatersys.com>

> ---
>  drivers/power/ds2782_battery.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index 6957e8a..4d2dc4f 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -393,6 +393,7 @@ static const struct i2c_device_id ds278x_id[] = {
>  	{"ds2786", DS2786},
>  	{},
>  };
> +MODULE_DEVICE_TABLE(i2c, ds278x_id);
>  
>  static struct i2c_driver ds278x_battery_driver = {
>  	.driver 	= {


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
