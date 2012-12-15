Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2LOLGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 06:06:13 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38533 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2LOLGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 06:06:10 -0500
Message-ID: <50CC599E.8060004@kernel.org>
Date: Sat, 15 Dec 2012 11:06:06 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/4 RESEND] iio: Add Usage IDs for HID time sensors.
References: <50C73AFC.1050904@jic23.retrosnub.co.uk> <1355250106-3114-1-git-send-email-holler@ahsoftware.de> <1355250106-3114-2-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1355250106-3114-2-git-send-email-holler@ahsoftware.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 06:21 PM, Alexander Holler wrote:
> These are Usage IDs for the attributes year, month, day,
> hour, minute and second, needed to read HID time sensors.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
This has gotten very messy to follow.  Could you resend the
patches (without the first) with Jiri cc'd as well
(as some of this is in his domain as HID maintainer).

Given this makes quite a few changes in IIO drivers I'm happy
to take the lot through the IIO tree but to do that I would
like a go ahead from Jiri + either Andrew or Alessandro
(for rtc side of things).

Alexander, you need to be careful with multi subsystem patches
like these to ensure everyone relevant is in the cc list.


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
> 
