Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0FAPfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:35:45 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:38502 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab0FAPfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:35:43 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 11:35:43 EDT
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Joe Perches <joe@perches.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: ISS StorageDev <iss_storagedev@hp.com>
Date: Tue, 1 Jun 2010 15:26:25 +0000
Subject: RE: [PATCH 04/21] drivers/block/cciss_scsi.c: Remove unnecessary
 kmalloc casts
Thread-Topic: [PATCH 04/21] drivers/block/cciss_scsi.c: Remove unnecessary
 kmalloc casts
Thread-Index: AcsBOc6H7I4yI0pQQ0+N9vQ4O91YhwAZOZBA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D012EFC8F@GVW0547EXC.americas.hpqcorp.net>
References: <cover.1275360951.git.joe@perches.com>
 <839dcab1f4fae391567c600dd515ede10232cfd4.1275360951.git.joe@perches.com>
In-Reply-To: <839dcab1f4fae391567c600dd515ede10232cfd4.1275360951.git.joe@perches.com>
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
> From: Joe Perches [mailto:joe@perches.com] 
> Sent: Monday, May 31, 2010 10:23 PM
> To: linux-kernel@vger.kernel.org
> Cc: Miller, Mike (OS Dev); ISS StorageDev
> Subject: [PATCH 04/21] drivers/block/cciss_scsi.c: Remove 
> unnecessary kmalloc casts
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss_scsi.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/cciss_scsi.c 
> b/drivers/block/cciss_scsi.c index e1d0e2c..ffd8470 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -702,8 +702,7 @@ cciss_scsi_setup(int cntl_num)
>  	struct cciss_scsi_adapter_data_t * shba;
>  
>  	ccissscsi[cntl_num].ndevices = 0;
> -	shba = (struct cciss_scsi_adapter_data_t *)
> -		kmalloc(sizeof(*shba), GFP_KERNEL);	
> +	shba = kmalloc(sizeof(*shba), GFP_KERNEL);
>  	if (shba == NULL)
>  		return;
>  	shba->scsi_host = NULL;
> --
> 1.7.0.3.311.g6a6955
> 
> 