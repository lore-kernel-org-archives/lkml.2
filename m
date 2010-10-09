Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab0JIXn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 19:43:56 -0400
Received: from xenotime.net ([72.52.115.56]:34608 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754047Ab0JIXnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 19:43:55 -0400
Date: Sat, 9 Oct 2010 16:43:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 4/5] misc: update apds990x driver to Kconfig and
 Makefile
Message-Id: <20101009164353.427f0cc9.rdunlap@xenotime.net>
In-Reply-To: <1286545324-18506-5-git-send-email-samu.p.onkalo@nokia.com>
References: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
	<1286545324-18506-5-git-send-email-samu.p.onkalo@nokia.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Oct 2010 16:42:03 +0300 Samu Onkalo wrote:

> Compilation support for apds990x driver
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  drivers/misc/Kconfig  |   11 +++++++++++
>  drivers/misc/Makefile |    1 +
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index f2e8065..cc7c363 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -324,6 +324,17 @@ config SENSORS_BHSFH
>             To compile this driver as a module, choose M here: the
>             module will be called bhsfh. If unsure, say N here.
>  
> +config SENSORS_APDS990X
> +	 tristate "APDS990X combined als and proximity sensors"
> +	 depends on I2C
> +	 default n
> +	 ---help---
> +	   Say Y here if you want to build a driver for Avago APDS990x
> +	   combined ambient light and proximity sensor chip

end sentence with period ('.')

> +
> +	   To compile this driver as a module, choose M here: the
> +	   module will be called apds990x. If unsure, say N here.
> +
>  config HMC6352
>  	tristate "Honeywell HMC6352 compass"
>  	depends on I2C
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index fd5a4b7..b90cea7 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
>  obj-$(CONFIG_PHANTOM)		+= phantom.o
>  obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
>  obj-$(CONFIG_SENSORS_BHSFH)	+= bhsfh.o
> +obj-$(CONFIG_SENSORS_APDS990X)	+= apds990x.o
>  obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
>  obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
>  obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
