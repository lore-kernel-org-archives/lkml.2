Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab0ICTZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 15:25:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59936 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab0ICTZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 15:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Hl8AgllzGEpio5hVKcMzTgCuKbzjN+8tQx0sUjYhCV40SzBE2SH3tDGLO+yF84KjGd
         xkAF6RNgtPeIg8H/D/YjYwF516bAVmAq6lD4cLW9u64o5dnYRLYGJb7Pwem6RYyMgwRf
         p5jUk/am9zfXbz4cWE6wfXAXqPpL2gVhVgvqI=
Date: Fri, 3 Sep 2010 21:24:46 +0200
From: Dan Carpenter <error27@gmail.com>
To: Gorskin Ilya <revent82@gmail.com>
Cc: gregkh@suse.de, mchehab@redhat.com, palash.bandyopadhyay@conexant.com,
        olimpiu.pascariu@gmail.com, laurent.pinchart@ideasonboard.com,
        peterhuewe@gmx.de, tsg321@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: cx25821: fix coding style issue in
	cx25821-audio-upstream.h, cx25821-core.c, cx25821-i2c.c,
	cx25821-medusa-reg.h, cx25821-medusa-video.c
Message-ID: <20100903192446.GK5437@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Gorskin Ilya <revent82@gmail.com>, gregkh@suse.de,
	mchehab@redhat.com, palash.bandyopadhyay@conexant.com,
	olimpiu.pascariu@gmail.com, laurent.pinchart@ideasonboard.com,
	peterhuewe@gmx.de, tsg321@gmail.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1283538384-12227-1-git-send-email-revent82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283538384-12227-1-git-send-email-revent82@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 12:26:24AM +0600, Gorskin Ilya wrote:
> @@ -977,8 +977,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
>  	dev->lmmio = ioremap(dev->base_io_addr, pci_resource_len(dev->pci, 0));
>  
>  	if (!dev->lmmio) {
> -		CX25821_ERR
> -		    ("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
> +		CX25821_ERR("ioremap failed,
> +			    maybe increasing __VMALLOC_RESERVE in page.h\n");
>  		cx25821_iounmap(dev);
>  		return -ENOMEM;
>  	}

You didn't try compile this.


> --- a/drivers/staging/cx25821/cx25821-medusa-video.c
> +++ b/drivers/staging/cx25821/cx25821-medusa-video.c
> @@ -500,8 +500,8 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
>  	/* validate the width - cannot be negative */
>  	if (width > MAX_WIDTH) {
>  		printk
> -		    ("cx25821 %s() : width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH\n",
> -		     __func__, width, MAX_WIDTH);
> +		    ("cx25821 %s() : width %d > MAX_WIDTH %d !
> +		    resetting to MAX_WIDTH\n", __func__, width, MAX_WIDTH);
>  		width = MAX_WIDTH;
>  	}

The string is damaged here.  We don't want those tabs in the final
output.

Please look the patch over again and resend.  There maybe some other
things I missed.  Wait a day between writing patches and sending them
so that you can review it with fresh eyes.

regards,
dan carpenter
