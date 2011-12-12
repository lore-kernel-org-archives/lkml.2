Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1LLJZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:25:39 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:42697 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1LLJZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:25:38 -0500
X-IronPort-AV: E=Sophos;i="4.71,337,1320624000"; 
   d="scan'208";a="9410021"
Subject: Re: [Xen-devel] [PATCH 5/6] xen/xenbus-frontend: Make error message
 more clear
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Mon, 12 Dec 2011 09:25:37 +0000
In-Reply-To: <1323541791-18006-6-git-send-email-waldi@debian.org>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
	 <1323541791-18006-6-git-send-email-waldi@debian.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323681937.20077.97.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 18:29 +0000, Bastian Blank wrote:
> Add the work frontend to the error message because we now also have a
> backend device.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>
Acked-by: Ian Campbell <ian.campbell@citrix.com>

> ---
>  drivers/xen/xenbus/xenbus_dev_frontend.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
> index fb30cff..9f6be7d 100644
> --- a/drivers/xen/xenbus/xenbus_dev_frontend.c
> +++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
> @@ -611,7 +611,7 @@ static int __init xenbus_init(void)
>  
>  	err = misc_register(&xenbus_dev);
>  	if (err)
> -		printk(KERN_ERR "Could not register xenbus device\n");
> +		printk(KERN_ERR "Could not register xenbus frontend device\n");
>  	return err;
>  }
>  


