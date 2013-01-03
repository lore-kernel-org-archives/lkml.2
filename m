Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3ACJlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:41:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3ACJk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:40:59 -0500
Date: Thu, 3 Jan 2013 10:40:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4 RESEND] iio: Add Usage IDs for HID time sensors.
In-Reply-To: <1355575537-10093-1-git-send-email-holler@ahsoftware.de>
Message-ID: <alpine.LNX.2.00.1301031040260.27348@pobox.suse.cz>
References: <50CC6FE3.6060705@ahsoftware.de> <1355575537-10093-1-git-send-email-holler@ahsoftware.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2012, Alexander Holler wrote:

> These are Usage IDs for the attributes year, month, day,
> hour, minute and second, needed to read HID time sensors.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

> ---
>  include/linux/hid-sensor-ids.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/hid-sensor-ids.h b/include/linux/hid-sensor-ids.h
> index ca8d7e9..3754ea9 100644
> --- a/include/linux/hid-sensor-ids.h
> +++ b/include/linux/hid-sensor-ids.h
> @@ -67,6 +67,15 @@
>  #define HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS		0x200486
>  #define HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS		0x200487
>  
> +/* Time (2000a0) */
> +#define HID_USAGE_SENSOR_TIME					0x2000a0
> +#define HID_USAGE_SENSOR_TIME_YEAR				0x200521
> +#define HID_USAGE_SENSOR_TIME_MONTH				0x200522
> +#define HID_USAGE_SENSOR_TIME_DAY				0x200523
> +#define HID_USAGE_SENSOR_TIME_HOUR				0x200525
> +#define HID_USAGE_SENSOR_TIME_MINUTE				0x200526
> +#define HID_USAGE_SENSOR_TIME_SECOND				0x200527
> +
>  /* Units */
>  #define HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED			0x00
>  #define HID_USAGE_SENSOR_UNITS_LUX				0x01
> -- 
> 1.7.8.6
> 

-- 
Jiri Kosina
SUSE Labs
