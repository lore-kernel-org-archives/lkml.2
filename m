Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0IFKNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:13:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52135 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0IFKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=o5P/7TdRjn1td38Wocn50WVpKKGO49CPGf6pblFm600igNVL7MUTmxWF/AtaGqWuJJ
         /+/Yrez8gpAdG4yu5so+HFuwu+zxLa1tCHNyHxjDONiEpjPAtNWkkf+04IYuO9yPUz+r
         asTAbNxFPvOwoornYorXEhs+q4mTA580s7TtQ=
Date: Mon, 6 Sep 2010 12:11:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Julia Lawall <julia@diku.dk>, Ben Hutchings <ben@decadent.org.uk>,
        Mike Gilks <mike.kernel@gilksonline.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] staging: rtl8192u: improve error path
Message-ID: <20100906101138.GA31249@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Julia Lawall <julia@diku.dk>, Ben Hutchings <ben@decadent.org.uk>,
	Mike Gilks <mike.kernel@gilksonline.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1283711561-7332-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283711561-7332-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 10:32:41PM +0400, Kulikov Vasiliy wrote:
> +fail2:
> +	rtl8192_down(dev);
> +	if (priv->pFirmware) {
> +		kfree(priv->pFirmware);
> +		priv->pFirmware = NULL;
> +	}
> +	rtl8192_usb_deleteendpoints(dev);
> +	destroy_workqueue(priv->priv_wq);
> +	mdelay(10);

What's this delay for?

regards,
dan carpenter

>  fail:
>  	free_ieee80211(dev);

