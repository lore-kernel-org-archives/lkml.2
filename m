Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1HWPRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:17:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25499 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab1HWPRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:17:45 -0400
MIME-Version: 1.0
Message-ID: <319475b8-897e-4c32-b781-2c86541f0753@default>
Date: Tue, 23 Aug 2011 08:17:28 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de
Cc: ascardo@holoscopio.com, rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] staging: zcache: fix typos
References: <1314039008-8845-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1314039008-8845-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E53C493.011E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Monday, August 22, 2011 12:50 PM
> To: gregkh@suse.de
> Cc: ascardo@holoscopio.com; Dan Magenheimer; sjenning@linux.vnet.ibm.com; rdunlap@xenotime.net;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] staging: zcache: fix typos
> 
> The patch fixes two typos in zcache-main.c
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Seth, I'm not very familiar with the process but I think this
kind of patch can go through the trivial patch monkey. See
Documentation/SubmittingPatches.

> ---
>  drivers/staging/zcache/zcache-main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 855a5bb..82054c9 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -651,7 +651,7 @@ static unsigned int zv_max_zsize = (PAGE_SIZE / 8) * 7;
>  /*
>   * byte count defining poor *mean* compression; pages with greater zsize
>   * will be rejected until sufficient better-compressed pages are accepted
> - * driving the man below this threshold
> + * driving the mean below this threshold
>   */
>  static unsigned int zv_max_mean_zsize = (PAGE_SIZE / 8) * 5;
> 
> @@ -1993,7 +1993,7 @@ static int __init zcache_init(void)
>  		pr_info("zcache: frontswap enabled using kernel "
>  			"transcendent memory and xvmalloc\n");
>  		if (old_ops.init != NULL)
> -			pr_warning("ktmem: frontswap_ops overridden");
> +			pr_warning("zcache: frontswap_ops overridden");
>  	}
>  #endif
>  out:
> --
> 1.7.4.1
> 
