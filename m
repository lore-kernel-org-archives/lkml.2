Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0IMUHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:07:09 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:2854 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833Ab0IMUHI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:07:08 -0400
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 13 Sep 2010 13:07:06 -0700
Subject: RE: [PATCH 14/25] drivers/net/vnxnet3: Use static const char arrays
Thread-Topic: [PATCH 14/25] drivers/net/vnxnet3: Use static const char arrays
Thread-Index: ActTfKe3WD3e01rlTxyZGm1B863yfQAAnC3A
Message-ID: <89E2752CFA8EC044846EB8499819134102BE8EEF9E@EXCH-MBX-4.vmware.com>
References: <cover.1284406638.git.joe@perches.com>
 <a2e0d6f77c221ebf7f642dd02da85bcd41947242.1284406638.git.joe@perches.com>
In-Reply-To: <a2e0d6f77c221ebf7f642dd02da85bcd41947242.1284406638.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joe.

Acked-by: Shreyas Bhatewara <sbhatewara@vmware.com>

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, September 13, 2010 12:48 PM
> To: linux-kernel@vger.kernel.org
> Cc: Shreyas Bhatewara; VMware, Inc.; netdev@vger.kernel.org
> Subject: [PATCH 14/25] drivers/net/vnxnet3: Use static const char
> arrays
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c |    2 +-
>  drivers/net/vmxnet3/vmxnet3_int.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c
> b/drivers/net/vmxnet3/vmxnet3_drv.c
> index 198ce92..dfc0014 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -28,7 +28,7 @@
> 
>  #include "vmxnet3_int.h"
> 
> -char vmxnet3_driver_name[] = "vmxnet3";
> +const char vmxnet3_driver_name[] = "vmxnet3";
>  #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
> 
>  /*
> diff --git a/drivers/net/vmxnet3/vmxnet3_int.h
> b/drivers/net/vmxnet3/vmxnet3_int.h
> index 2121c73..201fcf7 100644
> --- a/drivers/net/vmxnet3/vmxnet3_int.h
> +++ b/drivers/net/vmxnet3/vmxnet3_int.h
> @@ -384,5 +384,5 @@ vmxnet3_create_queues(struct vmxnet3_adapter
> *adapter,
>  extern void vmxnet3_set_ethtool_ops(struct net_device *netdev);
>  extern struct net_device_stats *vmxnet3_get_stats(struct net_device
> *netdev);
> 
> -extern char vmxnet3_driver_name[];
> +extern const char vmxnet3_driver_name[];
>  #endif
> --
> 1.7.3.rc1

