Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2D3UCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:02:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50747 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2D3UCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:02:07 -0400
Date: Mon, 30 Apr 2012 23:04:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/iio/meter: fix the coding style problem
Message-ID: <20120430200444.GM6447@mwanda>
References: <1335813977-8096-1-git-send-email-josephdanielwalter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335813977-8096-1-git-send-email-josephdanielwalter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:26:17AM +0600, joseph daniel wrote:
> 
> Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
> ---
> Hi Lars,
> 	Thanks for review. how about the below change?

Slow down.  There is no rush.  It's better to sit on patches
overnight so you can review them carefully the next day.  Take the
time to write a proper changelog...

>  drivers/staging/iio/meter/ade7854-i2c.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/meter/ade7854-i2c.c b/drivers/staging/iio/meter/ade7854-i2c.c
> index 1e1faa0..52bdb05 100644
> --- a/drivers/staging/iio/meter/ade7854-i2c.c
> +++ b/drivers/staging/iio/meter/ade7854-i2c.c
> @@ -181,6 +181,7 @@ static int ade7854_i2c_read_reg_32(struct device *dev,
>  {
>  	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>  	struct ade7854_state *st = iio_priv(indio_dev);
> +	uint32_t value;

Use the endian notation here:

	__be32 value;

http://lwn.net/Articles/205624/

The rest looks fine to me.  Package it up like a proper patch and
resend.

regards,
dan carpenter

