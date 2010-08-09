Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0HIOjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:39:49 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:60359 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577Ab0HIOjq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:39:46 -0400
X-Greylist: delayed 1388 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Aug 2010 10:39:46 EDT
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Dan Carpenter <error27@gmail.com>, Julia Lawall <julia@diku.dk>
CC: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Moore, Eric" <Eric.Moore@lsi.com>
Date: Mon, 9 Aug 2010 19:46:13 +0530
Subject: RE: [PATCH] scsi: mpt2sas: Add space in printk
Thread-Topic: [PATCH] scsi: mpt2sas: Add space in printk
Thread-Index: Acs1PWFUy78se+4GSXutbUP7YVes3wCj8AMg
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB24902991CD597@inbmail02.lsi.com>
References: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk>
 <20100806075914.GS9031@bicker>
In-Reply-To: <20100806075914.GS9031@bicker>
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



> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Friday, August 06, 2010 1:29 PM
> To: Julia Lawall
> Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Moore, Eric;
> Desai, Kashyap
> Subject: [PATCH] scsi: mpt2sas: Add space in printk
> 
> Add a space in the output:
> old:  Discovery: (stop)discovery_status(0x%08x)
> new:  Discovery: (stop) discovery_status(0x%08x)
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> This goes on top of Julia's [PATCH 9/42] drivers/scsi: Adjust
> confusing if indentation
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 12faf64..562b909 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -532,7 +532,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER
> *ioc,
>  		    (event_data->ReasonCode ==
> MPI2_EVENT_SAS_DISC_RC_STARTED) ?
>  		    "start" : "stop");
>  		if (event_data->DiscoveryStatus)
> -			printk("discovery_status(0x%08x)",
> +			printk(" discovery_status(0x%08x)",
I don't see any significant reason for changing print. It not adding any benefit.
Thanks, Kashyap
>  			    le32_to_cpu(event_data->DiscoveryStatus));
>  		printk("\n");
>  		return;
