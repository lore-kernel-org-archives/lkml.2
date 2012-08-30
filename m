Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab2H3TAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:00:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab2H3TAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:00:00 -0400
From: Oliver Neukum <oneukum@suse.de>
To: "SeungGoo, Kim" <nolja.kim@samsung.com>, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] usbnet: code clean up using checkpatch
Date: Thu, 30 Aug 2012 20:58:42 +0200
Message-ID: <1414211.Mo8vinPyin@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc2-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1346325521-27388-1-git-send-email-nolja.kim@samsung.com>
References: <1346325521-27388-1-git-send-email-nolja.kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2012 20:18:41 SeungGoo, Kim wrote:
> @@ -748,8 +752,9 @@ int usbnet_open (struct net_device *net)
>                 goto done_nopm;
>         }
>  
> -       // put into "known safe" state
> -       if (info->reset && (retval = info->reset (dev)) < 0) {
> +       /* put into "known safe" state */
> +       retval = info->reset(dev);
> +       if (info->reset && retval < 0) {
>                 netif_info(dev, ifup, dev->net,
>                            "open reset fail (%d) usbnet usb-%s-%s, %s\n",

Dave,

please don't take this patch. It changes code and breaks the driver.
A great big NACK.

Kim,

please do not send coding style patches which change code.
As an exercise think about this piece of code.

	Regards
		Oliver



