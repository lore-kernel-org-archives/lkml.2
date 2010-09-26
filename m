Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0IZJiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:38:46 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:55620 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0IZJio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:38:44 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C9F15E7.6030003@cam.ac.uk>
Date: Sun, 26 Sep 2010 10:44:07 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Phillip Kurtenbach <pkurtenbach@googlemail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Phillip Kurtenbach <pkurtenbach@gmail.com>
Subject: Re: [PATCH] staging: iio: whitespace cleanup
References: <1285456269-27582-1-git-send-email-pkurtenbach@gmail.com>
In-Reply-To: <1285456269-27582-1-git-send-email-pkurtenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/10 00:11, Phillip Kurtenbach wrote:
> Fixed whitespace coding style issues.
> 
> Signed-off-by: Phillip Kurtenbach <pkurtenbach@gmail.com>
Thanks. Those two seem to have been there a long time!

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/industrialio-core.c |    2 +-
>  drivers/staging/iio/industrialio-ring.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index dd4d87a..c03e1ae 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -59,7 +59,7 @@ EXPORT_SYMBOL(__iio_change_event);
>   * are queued. Hence a client MUST open the chrdev before the ring buffer is
>   * switched on.
>   */
> - int __iio_push_event(struct iio_event_interface *ev_int,
> +int __iio_push_event(struct iio_event_interface *ev_int,
>  		     int ev_code,
>  		     s64 timestamp,
>  		     struct iio_shared_ev_pointer *
> diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
> index 6ab578e..972a41a 100644
> --- a/drivers/staging/iio/industrialio-ring.c
> +++ b/drivers/staging/iio/industrialio-ring.c
> @@ -312,7 +312,7 @@ ssize_t iio_read_ring_length(struct device *dev,
>  }
>  EXPORT_SYMBOL(iio_read_ring_length);
>  
> - ssize_t iio_write_ring_length(struct device *dev,
> +ssize_t iio_write_ring_length(struct device *dev,
>  			       struct device_attribute *attr,
>  			       const char *buf,
>  			       size_t len)

