Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2FJHS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 03:18:59 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53915 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2FJHS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 03:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1206100258400.15651@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206100258400.15651@swampdragon.chaosbits.net>
Date: Sun, 10 Jun 2012 12:48:56 +0530
Message-ID: <CAK9yfHysOb+FU-uppaRDYSWGJ=KEK6YhFifz9iS57ZFQDWc66Q@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] qla2xxx: Get rid of unneeded includes of version.h
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>,
        trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

I have already submitted a similar patch for this:

http://www.spinics.net/lists/linux-scsi/msg59815.html



On 10 June 2012 06:29, Jesper Juhl <jj@chaosbits.net> wrote:
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |    1 -
>  drivers/scsi/qla2xxx/qla_target.h |    2 --
>  2 files changed, 3 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 04f80eb..f7a49e4 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -26,7 +26,6 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <linux/version.h>
>  #include <linux/blkdev.h>
>  #include <linux/interrupt.h>
>  #include <linux/pci.h>
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index 9ec19bc..7df4df5 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -919,8 +919,6 @@ struct qla_tgt_srr_ctio {
>  #define QLA_TGT_XMIT_STATUS            2
>  #define QLA_TGT_XMIT_ALL               (QLA_TGT_XMIT_STATUS|QLA_TGT_XMIT_DATA)
>
> -#include <linux/version.h>
> -
>  extern struct qla_tgt_data qla_target;
>  /*
>  * Internal function prototypes
> --
> 1.7.10.4
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With warm regards,
Sachin
