Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2DSMuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:50:02 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:46571 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2DSMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:50:00 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F9009F1.5030504@cam.ac.uk>
Date: Thu, 19 Apr 2012 13:49:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: gregkh@linuxfoundation.org, max@stro.at, jbrenner@taosinc.com,
        bfreed@chromium.org, lars@metafoo.de, grundler@chromium.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHi V2 1/2] staging: iio: light: convert multiple spaces
 to tab
References: <1334825975-7062-1-git-send-email-ldewangan@nvidia.com> <1334825975-7062-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1334825975-7062-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/2012 9:59 AM, Laxman Dewangan wrote:
> Using tab inplace of multiple spaces for indenting.
>
> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>

See I remembered my name this time ;)
> ---
> As per Jonathan's feedback, creating this patch for only
> indenting cleanups.
>
>   drivers/staging/iio/light/Kconfig |   18 +++++++++---------
>   1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
> index 53b49f7..bb633f6 100644
> --- a/drivers/staging/iio/light/Kconfig
> +++ b/drivers/staging/iio/light/Kconfig
> @@ -4,15 +4,15 @@
>   menu "Light sensors"
>
>   config SENSORS_ISL29018
> -        tristate "ISL 29018 light and proximity sensor"
> -        depends on I2C
> -        default n
> -        help
> -         If you say yes here you get support for ambient light sensing and
> -         proximity infrared sensing from Intersil ISL29018.
> -         This driver will provide the measurements of ambient light intensity
> -         in lux, proximity infrared sensing and normal infrared sensing.
> -         Data from sensor is accessible via sysfs.
> +	tristate "ISL 29018 light and proximity sensor"
> +	depends on I2C
> +	default n
> +	help
> +	 If you say yes here you get support for ambient light sensing and
> +	 proximity infrared sensing from Intersil ISL29018.
> +	 This driver will provide the measurements of ambient light intensity
> +	 in lux, proximity infrared sensing and normal infrared sensing.
> +	 Data from sensor is accessible via sysfs.
>
>   config SENSORS_ISL29028
>   	tristate "Intersil ISL29028 Concurrent Light and Proximity Sensor"

