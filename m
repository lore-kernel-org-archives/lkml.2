Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2DJRgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:36:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45102 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756842Ab2DJRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:10 -0400
X-Sasl-enc: R47+EBwNTAmvrQWSBUA9HFYVtTiqZKapaf9kmPR6yv4o 1334079369
Date: Tue, 10 Apr 2012 10:36:08 -0700
From: Greg KH <greg@kroah.com>
To: Jon Brenner <jbrenner@taosinc.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5] TAOS tsl2x7x
Message-ID: <20120410173608.GA29862@kroah.com>
References: <1333385439.2151.1.camel@jonz-ub2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333385439.2151.1.camel@jonz-ub2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 11:50:39AM -0500, Jon Brenner wrote:
> TAOS device driver (version 5) for the tsl/tmd 2771 and 2772 device families (inc. all variants).
> 
> Signed-off-by: Jon Brenner <jbrenner@taosinc.com>
> ---
>  .../light/sysfs-bus-iio-light-tsl2583              |    6 +
>  .../light/sysfs-bus-iio-light-tsl2x7x              |   14 +
>  drivers/staging/iio/Documentation/sysfs-bus-iio    |    7 +
>  .../staging/iio/Documentation/sysfs-bus-iio-light  |    8 +-
>  .../iio/Documentation/sysfs-bus-iio-light-tsl2583  |   20 -
>  drivers/staging/iio/light/Kconfig                  |    8 +
>  drivers/staging/iio/light/Makefile                 |    2 +
>  drivers/staging/iio/light/tsl2x7x.h                |   99 ++
>  drivers/staging/iio/light/tsl2x7x_core.c           | 1830 ++++++++++++++++++++
>  9 files changed, 1970 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583 b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
> new file mode 100644
> index 0000000..8f2a038
> --- /dev/null
> +++ b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
> @@ -0,0 +1,6 @@
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
> +KernelVersion:	2.6.37

Really?  Are we traveling back in time now?

confused...

I need an ack from Jonathan before I can take this.

thanks,

greg k-h
