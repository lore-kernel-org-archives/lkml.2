Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0F1TGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:06:31 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34086 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0F1TG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:06:29 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Kulikov Vasiliy <segooon@gmail.com>,
       "trivial@kernel.org" <trivial@kernel.org>
CC: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Patterson, Andrew D (LeftHand Networks)" <andrew.patterson@hp.com>,
       ISS StorageDev <iss_storagedev@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 28 Jun 2010 19:05:10 +0000
Subject: RE: [PATCH 01/16] trivial: use ARRAY_SIZE
Thread-Topic: [PATCH 01/16] trivial: use ARRAY_SIZE
Thread-Index: AcsWuLWBs6K6g8vSR2eD1tvYgOP9AwAPA/gw
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D03473B46@GVW0547EXC.americas.hpqcorp.net>
References: <1277726085-24434-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1277726085-24434-1-git-send-email-segooon@gmail.com>
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
> From: Kulikov Vasiliy [mailto:segooon@gmail.com] 
> Sent: Monday, June 28, 2010 6:55 AM
> To: trivial@kernel.org
> Cc: Kernel Janitors; Miller, Mike (OS Dev); Jens Axboe; 
> Stephen M. Cameron; Andrew Morton; Patterson, Andrew D 
> (LeftHand Networks); ISS StorageDev; linux-kernel@vger.kernel.org
> Subject: [PATCH 01/16] trivial: use ARRAY_SIZE
> 
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Acked-by: Mike Miller <mike.miller@hp.com>
> ---
>  drivers/block/cciss.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> index 51ceaee..e1e7143 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -335,7 +335,7 @@ static void 
> cciss_map_sg_chain_block(ctlr_info_t *h, CommandList_struct 
> *c,  static const char *raid_label[] = { "0", "4", "1(1+0)", 
> "5", "5+1", "ADG",
>  	"UNKNOWN"
>  };
> -#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0])-1)
> +#define RAID_UNKNOWN (ARRAY_SIZE(raid_label)-1)
>  
>  #ifdef CONFIG_PROC_FS
>  
> --
> 1.7.0.4
> 
> 