Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab0JQTT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 15:19:56 -0400
Received: from xenotime.net ([72.52.115.56]:39259 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932392Ab0JQTTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 15:19:55 -0400
Date: Sun, 17 Oct 2010 12:19:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] ad525x_dpot: default to off
Message-Id: <20101017121953.40831b35.rdunlap@xenotime.net>
In-Reply-To: <1287296545-21822-1-git-send-email-vapier@gentoo.org>
References: <1287296545-21822-1-git-send-email-vapier@gentoo.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010 02:22:25 -0400 Mike Frysinger wrote:

> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> No reason for this to be enabled by default.

The default is automatically 'n', so please explain (more) why this is
needed...?

> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b743312..7691f89 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -16,6 +16,7 @@ if MISC_DEVICES
>  config AD525X_DPOT
>  	tristate "Analog Devices Digital Potentiometers"
>  	depends on (I2C || SPI) && SYSFS
> +	default n
>  	help
>  	  If you say yes here, you get support for the Analog Devices
>  	  AD5258, AD5259, AD5251, AD5252, AD5253, AD5254, AD5255
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
