Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1HAQOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:14:34 -0400
Received: from mail.perches.com ([173.55.12.10]:4436 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab1HAQOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:14:24 -0400
Subject: Re: [PATCH] Staging: cx25821: fix coding style issues
From: Joe Perches <joe@perches.com>
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, mchehab@redhat.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        Palash.Bandyopadhyay@conexant.com, ruslan@rpisarev.org.ua,
        Revent82@gmail.com
In-Reply-To: <1312191229-24718-1-git-send-email-leonidsbox@gmail.com>
References: <1312191229-24718-1-git-send-email-leonidsbox@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 09:14:22 -0700
Message-ID: <1312215262.11635.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 17:33 +0800, Leonid V. Fedorenchik wrote:
> Fix too long lines in cx25821-audio.h and cx25821-core.c
[]
> diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
[]
> @@ -972,8 +972,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
>  	dev->lmmio = ioremap(dev->base_io_addr, pci_resource_len(dev->pci, 0));
>  
>  	if (!dev->lmmio) {
> -		CX25821_ERR
> -		    ("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
> +		CX25821_ERR("ioremap failed, maybe increasing __VMALLOC_RESERVE"
> +								" in page.h\n");

Please do not split formats.

>  		cx25821_iounmap(dev);
>  		return -ENOMEM;
>  	}
> @@ -1011,8 +1011,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
>  	if (video_register_device
>  	    (dev->ioctl_dev, VFL_TYPE_GRABBER, VIDEO_IOCTL_CH) < 0) {
>  		cx25821_videoioctl_unregister(dev);
> -		pr_err("%s(): Failed to register video adapter for IOCTL, so unregistering videoioctl device\n",
> -		       __func__);
> +		pr_err("%s(): Failed to register video adapter for IOCTL, so "
> +				"unregistering videoioctl device\n", __func__);

This was better before the change.

> -static struct pci_device_id cx25821_pci_tbl[] = {
> +static DEFINE_PCI_DEVICE_TABLE(cx25821_pci_tbl) __used = {

__used?  Hard to believe that's necessary here.


