Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2DRUN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:13:26 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58746 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754272Ab2DRUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:13:24 -0400
Message-ID: <4F8F2087.9090900@xenotime.net>
Date: Wed, 18 Apr 2012 13:13:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-usb@vger.kernel.org, stern@rowland.harvard.edu, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] usb: Fix various typo within usb
References: <1334761486-12817-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1334761486-12817-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 08:04 AM, Masanari Iida wrote:

> Correct spelling typo within usb
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/usb/gadget/f_hid.c       |    2 +-
>  drivers/usb/host/ehci-platform.c |    4 ++--
>  drivers/usb/host/fhci-tds.c      |    2 +-
>  drivers/usb/host/ohci-platform.c |    4 ++--
>  drivers/usb/host/ohci-ppc-of.c   |    2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
> index d238b4e2..23c530a 100644
> --- a/drivers/usb/host/ehci-platform.c
> +++ b/drivers/usb/host/ehci-platform.c
> @@ -94,12 +94,12 @@ static int __devinit ehci_platform_probe(struct platform_device *dev)
>  
>  	irq = platform_get_irq(dev, 0);
>  	if (irq < 0) {
> -		pr_err("no irq provieded");
> +		pr_err("no irq provided");
>  		return irq;
>  	}
>  	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	if (!res_mem) {
> -		pr_err("no memory recourse provieded");
> +		pr_err("no memory recourse provided");


		                  resource

>  		return -ENXIO;
>  	}
>  
> diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
> index ec5c679..670c705 100644
> --- a/drivers/usb/host/ohci-platform.c
> +++ b/drivers/usb/host/ohci-platform.c
> @@ -93,13 +93,13 @@ static int __devinit ohci_platform_probe(struct platform_device *dev)
>  
>  	irq = platform_get_irq(dev, 0);
>  	if (irq < 0) {
> -		pr_err("no irq provieded");
> +		pr_err("no irq provided");
>  		return irq;
>  	}
>  
>  	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	if (!res_mem) {
> -		pr_err("no memory recourse provieded");
> +		pr_err("no memory recourse provided");


		                  resource

>  		return -ENXIO;
>  	}
>  


-- 
~Randy
