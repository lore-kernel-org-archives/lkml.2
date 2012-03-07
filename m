Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab2CGUSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:18:16 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:20580 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab2CGUSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:18:14 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq3M7tG9A=
X-RZG-CLASS-ID: mo00
Date: Wed, 7 Mar 2012 21:17:46 +0100
From: Olaf Hering <olaf@aepfle.de>
To: davem@davemloft.net
Cc: Haiyang Zhang <haiyangz@microsoft.com>, kys@microsoft.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Message-ID: <20120307201746.GA20900@aepfle.de>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, Haiyang Zhang wrote:


> @@ -482,7 +484,7 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
>  
>  /* The one and only one */
>  static struct  hv_driver netvsc_drv = {
> -	.name = "netvsc",
> +	.name = MODULE_NAME,

It would be nice if this could be applied to 3.3.
hv_storvsc and hid-hyperv already use the same naming, this patch was
send last year already but was not applied for some reason.

Olaf
