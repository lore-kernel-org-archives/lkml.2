Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0DGVXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:23:18 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:49698 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0DGVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:23:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.589
Message-ID: <4BBCF7BF.3070709@tremplin-utc.net>
Date: Wed, 07 Apr 2010 23:23:11 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] lis3: add support for HP ProBook 432x/442x/452x/522x
References: <s5h1verc7er.wl%tiwai@suse.de>
In-Reply-To: <s5h1verc7er.wl%tiwai@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-04-10 22:52, Takashi Iwai schreef:
> Correct axis-mappings for new HP ProBook laptops.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
Looks fine. Thanks Takashi!

Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

Eric
> ---
>  drivers/hwmon/hp_accel.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> index be475e8..c8ab505 100644
> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -217,6 +217,10 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
>  	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
>  	AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
>  	AXIS_DMI_MATCH("HDX18", "HP HDX 18", x_inverted),
> +	AXIS_DMI_MATCH("HPB432x", "HP ProBook 432", xy_rotated_left),
> +	AXIS_DMI_MATCH("HPB442x", "HP ProBook 442", xy_rotated_left),
> +	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
> +	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
>  	{ NULL, }
>  /* Laptop models without axis info (yet):
>   * "NC6910" "HP Compaq 6910"

