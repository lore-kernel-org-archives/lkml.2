Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2BCBFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:05:12 -0500
Received: from sr-smtp.usish.com ([210.5.144.203]:43027 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2BCBFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:05:10 -0500
X-Greylist: delayed 1002 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Feb 2012 20:05:10 EST
From: "Jack Wang" <jack_wang@usish.com>
To: "'Masanari Iida'" <standby24x7@gmail.com>, <lindar_liu@usish.com>,
        <linux-scsi@vger.kernel.org>
Cc: <trivial@kernel.org>, <linux-kernel@vger.kernel.org>
References: <1328203522-3862-1-git-send-email-standby24x7@gmail.com>
Subject: RE: [PATCH v2] [trivial] pm8001: Fix typo in pm8001_hwi.c
Date: Fri, 3 Feb 2012 08:46:32 +0800
Message-ID: <63F9BE2E1F114ADA8301965998CCDE03@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
In-Reply-To: <1328203522-3862-1-git-send-email-standby24x7@gmail.com>
Thread-Index: Aczh0CXE5v4/YUYLQxGAtbCbjRG+nAAPQEIg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, thanks for fix.

Acked-by : Jack Wang <jack_wang@usish.com>
> 
> Correct typo "unresgister" to "unregister" and "deviece" to
> "device" in drivers/scsi/pm8001/pm8001_hwi.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index b7b92f7..e12c4f6 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3532,7 +3532,7 @@ static void process_one_iomb(struct pm8001_hba_info
> *pm8001_ha, void *piomb)
>  		break;
>  	case OPC_OUB_DEREG_DEV:
>  		PM8001_MSG_DBG(pm8001_ha,
> -			pm8001_printk("unresgister the deviece\n"));
> +			pm8001_printk("unregister the device\n"));
>  		mpi_dereg_resp(pm8001_ha, piomb);
>  		break;
>  	case OPC_OUB_GET_DEV_HANDLE:
> --
> 1.7.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

