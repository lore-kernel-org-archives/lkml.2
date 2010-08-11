Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0HKRos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:44:48 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43800 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab0HKRor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:44:47 -0400
Subject: Re: [PATCH -next] hwmon: jc42 depends on I2C
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20100811103511.41428e62.randy.dunlap@oracle.com>
References: <20100811140009.6ff33109.sfr@canb.auug.org.au>
	 <20100811103511.41428e62.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Wed, 11 Aug 2010 10:43:31 -0700
Message-ID: <1281548611.5745.287.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 13:35 -0400, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> jc42 uses i2c interfaces, so it should depend on I2C.
> 
> drivers/hwmon/jc42.c:426: error: implicit declaration of function 'i2c_check_functionality'
> drivers/hwmon/jc42.c:521: error: implicit declaration of function 'i2c_smbus_read_word_data'
> drivers/hwmon/jc42.c:529: error: implicit declaration of function 'i2c_smbus_write_word_data'
> drivers/hwmon/jc42.c:580: error: implicit declaration of function 'i2c_add_driver'
> drivers/hwmon/jc42.c:585: error: implicit declaration of function 'i2c_del_driver'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	lm-sensors@lm-sensors.org
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

> ---
>  drivers/hwmon/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20100811.orig/drivers/hwmon/Kconfig
> +++ linux-next-20100811/drivers/hwmon/Kconfig
> @@ -465,6 +465,7 @@ config SENSORS_JZ4740
>  
>  config SENSORS_JC42
>  	tristate "JEDEC JC42.4 compliant temperature sensors"
> +	depends on I2C
>  	help
>  	  If you say yes here you get support for Jedec JC42.4 compliant
>  	  temperature sensors. Support will include, but not be limited to,


