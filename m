Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab0D3TAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:00:36 -0400
Received: from kroah.org ([198.145.64.141]:49559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab0D3RDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:03:33 -0400
Date: Thu, 29 Apr 2010 12:17:34 -0700
From: Greg KH <greg@kroah.com>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sdietrich@novell.com, sonic.adi@gmail.com, jic23@cam.ac.uk,
       akpm@linux-foundation.org, lindner_marek@yahoo.de
Subject: Re: Staging: iio: Fix remaining code style issues
Message-ID: <20100429191734.GA21615@kroah.com>
References: <1272562051-2098-1-git-send-email-roel.vannyen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272562051-2098-1-git-send-email-roel.vannyen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 07:27:31PM +0200, Roel Van Nyen wrote:
> fix code style issues
> 
> Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -810,7 +810,7 @@ int iio_device_register(struct iio_dev *dev_info)
>  	ret = iio_device_register_eventset(dev_info);
>  	if (ret) {
>  		dev_err(dev_info->dev.parent,
> -			"Failed to register event set \n");
> +			"Failed to register event set\n");
>  		goto error_free_sysfs;
>  	}
>  	if (dev_info->modes & INDIO_RING_TRIGGERED)
> diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
> index e95b6a4..4981803 100644
> --- a/drivers/staging/iio/ring_sw.c
> +++ b/drivers/staging/iio/ring_sw.c
> @@ -126,8 +126,7 @@ int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
>  		spin_lock(&ring->buf.shared_ev_pointer.lock);
>  
>  		ret = iio_push_or_escallate_ring_event(&ring->buf,
> -						       IIO_EVENT_CODE_RING_100_FULL,
> -						       timestamp);
> +			       IIO_EVENT_CODE_RING_100_FUL, timestamp);

You never tested this fix :(

It breaks the build, please be more careful next time.  I've fixed it
up...

thanks,

greg k-h
