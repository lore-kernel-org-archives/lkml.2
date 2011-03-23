Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1CWLKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:10:24 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:41735 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1CWLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:10:23 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D89D56A.4090908@cam.ac.uk>
Date: Wed, 23 Mar 2011 11:11:38 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: cliff.cai@analog.com
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        drivers@analog.com, device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/3] Add MACRO for gyro quadrature correction
References: <1300871727-32239-1-git-send-email-cliff.cai@analog.com>
In-Reply-To: <1300871727-32239-1-git-send-email-cliff.cai@analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/11 09:15, cliff.cai@analog.com wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Add gyro_z_quadrature_correction_raw define.
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/gyro/gyro.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/gyro/gyro.h b/drivers/staging/iio/gyro/gyro.h
> index b4ea5bf..b549561 100644
> --- a/drivers/staging/iio/gyro/gyro.h
> +++ b/drivers/staging/iio/gyro/gyro.h
> @@ -57,6 +57,9 @@
>  #define IIO_DEV_ATTR_GYRO_Z_CALIBSCALE(_mode, _show, _store, _addr)		\
>  	IIO_DEVICE_ATTR(gyro_z_calibscale, _mode, _show, _store, _addr)
>  
> +#define IIO_DEV_ATTR_GYRO_Z_QUADRATURE_CORRECTION(_show, _addr)		\
> +	IIO_DEVICE_ATTR(gyro_z_quadrature_correction_raw, S_IRUGO, _show, NULL, _addr)
> +
>  #define IIO_DEV_ATTR_GYRO(_show, _addr)			\
>  	IIO_DEVICE_ATTR(gyro_raw, S_IRUGO, _show, NULL, _addr)
>  

