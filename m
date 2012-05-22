Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2EVMRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:17:11 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:58961 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab2EVMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:17:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FBB83BD.4020509@cam.ac.uk>
Date: Tue, 22 May 2012 13:17:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] staging:iio: remove num_interrupt_lines from documentation
References: <1337682602-15105-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1337682602-15105-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2012 11:30 AM, Johan Hovold wrote:
> Commit 5aa9618896e0ba49 ("staging:iio: remove broken support for
> multiple event interfaces.") removed the num_interrupt_lines field from
> struct iio_info but the documentation was never updated.
>
Good catch.
> Signed-off-by: Johan Hovold<jhovold@gmail.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>   drivers/staging/iio/Documentation/device.txt |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/iio/Documentation/device.txt b/drivers/staging/iio/Documentation/device.txt
> index 0338c7c..f03fbd3 100644
> --- a/drivers/staging/iio/Documentation/device.txt
> +++ b/drivers/staging/iio/Documentation/device.txt
> @@ -29,8 +29,6 @@ Then fill in the following:
>   	* info->driver_module:
>   		Set to THIS_MODULE. Used to ensure correct ownership
>   		of various resources allocate by the core.
> -	* info->num_interrupt_lines:
> -		Number of event triggering hardware lines the device has.
>   	* info->event_attrs:
>   		Attributes used to enable / disable hardware events.
>   	* info->attrs:

