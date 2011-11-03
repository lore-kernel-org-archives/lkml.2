Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043Ab1KCQa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:30:57 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:51947 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827Ab1KCQa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:30:56 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: NetDev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>
Subject: RE: [PATCH] staging: hv: move hv_netvsc into drivers/net directory
Thread-Topic: [PATCH] staging: hv: move hv_netvsc into drivers/net directory
Thread-Index: AQHMiq2Jg7/jUCwTj0+xVzg+xFomYpWbdKyA
Date: Thu, 3 Nov 2011 16:30:55 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0CC98B5B@TK5EX14MBXC221.redmond.corp.microsoft.com>
References: <1318624485-23865-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1318624485-23865-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> Sent: Friday, October 14, 2011 4:35 PM
> To: Haiyang Zhang; KY Srinivasan; gregkh@suse.de; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Cc: Mike Sterling; NetDev
> Subject: [PATCH] staging: hv: move hv_netvsc into drivers/net
> directory
> 
> hv_netvsc has been reviewed on netdev mailing list on 6/09/2011.
> All recommended changes have been made. We are requesting to move
> it from staging area into drivers/net directory.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: KY Srinivasan <kys@microsoft.com>
> Signed-off-by: Mike Sterling <Mike.Sterling@microsoft.com>
> Cc: NetDev <netdev@vger.kernel.org>
> 
> ---
>  drivers/net/Kconfig               |    2 +
>  drivers/net/Makefile              |    2 +
>  drivers/net/hyperv/Kconfig        |    5 +
>  drivers/net/hyperv/Makefile       |    3 +
>  drivers/net/hyperv/hyperv_net.h   | 1058
> +++++++++++++++++++++++++++++++++++++
>  drivers/net/hyperv/netvsc.c       |  944
> +++++++++++++++++++++++++++++++++
>  drivers/net/hyperv/netvsc_drv.c   |  456 ++++++++++++++++
>  drivers/net/hyperv/rndis_filter.c |  855
> ++++++++++++++++++++++++++++++
>  8 files changed, 3325 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/hyperv/Kconfig
>  create mode 100644 drivers/net/hyperv/Makefile
>  create mode 100644 drivers/net/hyperv/hyperv_net.h
>  create mode 100644 drivers/net/hyperv/netvsc.c
>  create mode 100644 drivers/net/hyperv/netvsc_drv.c
>  create mode 100644 drivers/net/hyperv/rndis_filter.c
> 

Hi Dave,

Do you have any comments on this patch which requesting hv_netvsc
out of staging area?

Thanks,
- Haiyang

