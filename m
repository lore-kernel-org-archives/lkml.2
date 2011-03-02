Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1CBWuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:50:18 -0500
Received: from mail.perches.com ([173.55.12.10]:4051 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab1CBWuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:50:16 -0500
Subject: Re: [Qualcomm PM8921 MFD 5/6] MAINTAINERS: Add pmic8921, pmic8xxx
 subdevices maintainers
From: Joe Perches <joe@perches.com>
To: adharmap@codeaurora.org
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299104001-5240-6-git-send-email-adharmap@codeaurora.org>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
	 <1299104001-5240-6-git-send-email-adharmap@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 14:50:13 -0800
Message-ID: <1299106213.4208.112.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 14:13 -0800, adharmap@codeaurora.org wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS

The patch subject is not quite correct.
You're adding patterns, not maintainers.

> index 696cb18..97107fd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -905,6 +905,12 @@ F:	drivers/mmc/host/msm_sdcc.h
>  F:	drivers/tty/serial/msm_serial.h
>  F:	drivers/tty/serial/msm_serial.c
>  F:	drivers/platform/msm/
> +F:	drivers/mfd/pm8921-core.c
> +F:	drivers/mfd/pm8xxx-mpp.c
> +F:	include/linux/mfd/pm8921.h
> +F:	include/linux/mfd/pm8xxx/
> +F:	drivers/gpio/pm8xxx-gpio.c
> +F:	drivers/mfd/pm8xxx-irq.c

My preference is to keep these in alphabetic order.

Another option is a wildcard pattern match like:

F:	drivers/*/pm8???-*

instead of:

F:	drivers/gpio/pm8xxx-gpio.c
F:	drivers/mfd/pm8921-core.c
F:	drivers/mfd/pm8xxx-irq.c
F:	drivers/mfd/pm8xxx-mpp.c


