Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1JQNm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:42:28 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:43524 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab1JQNm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:42:26 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 1/6] IIO: Core sysfs only support.
Date: Mon, 17 Oct 2011 15:42:23 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.6-gentoo; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        guenter.roeck@ericsson.com, khali@linux-fr.org,
        dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de
References: <1318857381-13787-1-git-send-email-jic23@cam.ac.uk> <1318857381-13787-2-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1318857381-13787-2-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171542.24673.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan,

On Monday 17 October 2011 15:16:16 you wrote:
> Add support for simple sysfs only interfaces.
> 
> Bulk of patch is concerned with taking struct iio_chan_spec
> arrays and generating all the relevant interfaces from them.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/Kconfig           |    2 +
>  drivers/Makefile          |    3 +
>  drivers/iio/Kconfig       |   11 +
>  drivers/iio/Makefile      |    6 +
>  drivers/iio/iio.c         |  591
> +++++++++++++++++++++++++++++++++++++++++++++ include/linux/iio/iio.h   | 
> 250 +++++++++++++++++++
>  include/linux/iio/sysfs.h |   68 +++++
>  7 files changed, 931 insertions(+), 0 deletions(-)
> 
> [...]
> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> new file mode 100644
> index 0000000..5d9a97d
> --- /dev/null
> +++ b/drivers/iio/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# Industrial I/O subsystem
> +#
> +
> +menuconfig IIO
> +	tristate "Industrial I/O support"
> +	depends on GENERIC_HARDIRQS
> +	help
> +	  The Industrial input / output subsystem provides a unified
> +	  framework for many different types of embedded sensor.
> +	  See Documentation/iio for more information.

I don't know much about iio so I want to read about it. But where does 
Documentation/iio come from?

Regards,
Alexander
