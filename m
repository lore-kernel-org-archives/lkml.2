Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1DMNJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:09:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43331 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1DMNJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:09:03 -0400
Date: Wed, 13 Apr 2011 15:08:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] hwmon, fam15h_power: Add maintainers entry
Message-ID: <20110413150855.21542d6e@endymion.delvare>
In-Reply-To: <20110408135746.GB12014@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
	<20110405144536.GA5054@alberich.amd.com>
	<20110406135424.GC2177@alberich.amd.com>
	<20110408135746.GB12014@alberich.amd.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Fri, 8 Apr 2011 15:57:46 +0200, Andreas Herrmann wrote:
> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> As suggested by Jean, here's a patch to add a maintainers
> entry for the new driver.
> 
> 
> Regards,
> 
> Andreas
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b4b9cd..af8421d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -483,6 +483,13 @@ F:	drivers/tty/serial/altera_jtaguart.c
>  F:	include/linux/altera_uart.h
>  F:	include/linux/altera_jtaguart.h
>  
> +AMD FAM15H PROCESSOR POWER HARDWARE MONITORING DRIVER

I'd remove "HARDWARE" as the target hardware is already described.

> +M:	Andreas Herrmann <andreas.herrmann3@amd.com>
> +L:	lm-sensors@lm-sensors.org
> +S:	Maintained
> +F:	Documentation/hwmon/fam15h_power
> +F:	drivers/hwmon/fam15h_power.c
> +
>  AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
>  M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
>  L:	linux-geode@lists.infradead.org (moderated for non-subscribers)

Other than this small detail, which I can fix myself if you agree with
me, this looks good, thanks for stepping in!

-- 
Jean Delvare
