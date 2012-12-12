Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2LLUK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:10:28 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:41423 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:10:27 -0500
Message-ID: <50C8E49C.70106@ahsoftware.de>
Date: Wed, 12 Dec 2012 21:10:04 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] iio: merge hid-sensor-attributes.h into hid-sensor-hub.h
References: <50C73AFC.1050904@jic23.retrosnub.co.uk> <1355250106-3114-1-git-send-email-holler@ahsoftware.de> <1355250106-3114-3-git-send-email-holler@ahsoftware.de> <4FA419E87744DF4DAECD5BCE1214B7A91C960BAB@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <4FA419E87744DF4DAECD5BCE1214B7A91C960BAB@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.12.2012 16:45, schrieb Pandruvada, Srinivas:
>
> One minor comment.

> +/* hid-sensor-attributes */
> +
> +/* Common hid sensor iio structure */
> +struct hid_sensor_iio_common {
> +	struct hid_sensor_hub_device *hsdev;
> +	struct platform_device *pdev;
> +	unsigned usage_id;
> +	bool data_ready;
> +	struct hid_sensor_hub_attribute_info poll;
> +	struct hid_sensor_hub_attribute_info report_state;
> +	struct hid_sensor_hub_attribute_info power_state;
> +	struct hid_sensor_hub_attribute_info sensitivity; };
>
> <Since it is not common to iio only, we should also remove iio in the structure name. >
>

Ok, I play the patch-monkey and will send a patch 5/4.

Alexander
