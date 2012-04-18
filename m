Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2DRPt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:49:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753872Ab2DRPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:49:55 -0400
Date: Wed, 18 Apr 2012 11:49:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Masanari Iida <standby24x7@gmail.com>
cc: linux-usb@vger.kernel.org, <trivial@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [trivial] usb: Fix various typo within usb
In-Reply-To: <1334761486-12817-1-git-send-email-standby24x7@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1204181134061.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Masanari Iida wrote:

> Correct spelling typo within usb

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

This is a good thing to do, but you should fix the spelling of 
"resource" as well.  Also in ohci-platform.c.

Alan Stern


