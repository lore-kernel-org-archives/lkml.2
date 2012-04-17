Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2DQUbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:31:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2DQUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:31:23 -0400
Date: Tue, 17 Apr 2012 22:31:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        cjb@laptop.org, svenkatr@ti.com
Subject: Re: [PATCH v2] mmc: cd-gpio.c: Include header to pickup exported
 symbol prototypes
In-Reply-To: <201204171303.39744.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.64.1204172230540.27488@axis700.grange>
References: <201204171303.39744.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:RgGwbbfudLAuoEMxjayhdcFqBWp9VJnJmfh+ewmOeXW
 q7fXZRDYhQMp9dxdRx9CPY5VTgnQedXiugI/QobtG2za6iSrhr
 5xrT7eCkc3gcdBVcC63p9ToLFR9JpV/sQP3pRTZ6DrO7MHgtRy
 gigwmiWC9uZa/Avtqf+eUz84TEA9ndOzIO6Ifj2XgqY9zFJIn4
 /mne4RvCGxKiiXPNAgOGNchnrNE05OIrOJUNLgvpSTjE5YuK2K
 7rV18lH1fr+vnq6K9B2TV+giy/ERmP2Am6MNkPyVQJoLIsKVOn
 KvGr53S+ujTc0Zr/+mACYGq2IUZk148g5YRMb3P8PV91XHcjp+
 12i45yF4uv+d8OfoW+xZPDv1vAAjK7a5iRca2nAyLoEq78u7gk
 xuNFzWz4/xDnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, H Hartley Sweeten wrote:

> Include the linux/mmc/cd-gpio.h header to pickup the prototypes
> for the two exported symbols.
> 
> This quiets the sparse warnings:
> 
> warning: symbol 'mmc_cd_gpio_request' was not declared. Should it be static?
> warning: symbol 'mmc_cd_gpio_free' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Acked-by: Venkatraman S <svenkatr@ti.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> 
> ---
> 
> v2: add new header alphabetically
> 
> diff --git a/drivers/mmc/core/cd-gpio.c b/drivers/mmc/core/cd-gpio.c
> index 29de31e..2c14be7 100644
> --- a/drivers/mmc/core/cd-gpio.c
> +++ b/drivers/mmc/core/cd-gpio.c
> @@ -12,6 +12,7 @@
>  #include <linux/gpio.h>
>  #include <linux/interrupt.h>
>  #include <linux/jiffies.h>
> +#include <linux/mmc/cd-gpio.h>
>  #include <linux/mmc/host.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
