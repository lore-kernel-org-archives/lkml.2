Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab1GFThA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:37:00 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:48441 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab1GFTg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:36:58 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E14BB35.5070800@cam.ac.uk>
Date: Wed, 06 Jul 2011 20:44:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, rklein@nvidia.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] staging:iio: Reorder channel type strings to match
 the iio.h enums.
References: <1309978586-10092-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1309978586-10092-1-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/11 19:56, Bryan Freed wrote:
> This makes comparison between the iio_chan_type_name_spec_shared strings
> and the iio_chan_type enums easier.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/industrialio-core.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 94d3bfa..4987bf4 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -44,20 +44,20 @@ struct bus_type iio_bus_type = {
>  EXPORT_SYMBOL(iio_bus_type);
>  
>  static const char * const iio_chan_type_name_spec_shared[] = {
> -	[IIO_TIMESTAMP] = "timestamp",
> -	[IIO_ACCEL] = "accel",
>  	[IIO_IN] = "in",
>  	[IIO_CURRENT] = "current",
>  	[IIO_POWER] = "power",
> +	[IIO_ACCEL] = "accel",
>  	[IIO_IN_DIFF] = "in-in",
>  	[IIO_GYRO] = "gyro",
> -	[IIO_TEMP] = "temp",
>  	[IIO_MAGN] = "magn",
> +	[IIO_LIGHT] = "illuminance",
> +	[IIO_INTENSITY] = "intensity",
> +	[IIO_TEMP] = "temp",
>  	[IIO_INCLI] = "incli",
>  	[IIO_ROT] = "rot",
> -	[IIO_INTENSITY] = "intensity",
> -	[IIO_LIGHT] = "illuminance",
>  	[IIO_ANGL] = "angl",
> +	[IIO_TIMESTAMP] = "timestamp",
>  };
>  
>  static const char * const iio_chan_type_name_spec_complex[] = {

