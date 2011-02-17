Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1BQQmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:42:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab1BQQmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:42:39 -0500
Date: Thu, 17 Feb 2011 17:42:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers:scsi Change initate to initiate.
In-Reply-To: <1296244148-3808-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1102171742190.2160@pobox.suse.cz>
References: <1296244148-3808-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011, Justin P. Mattock wrote:

> Not sure if this is a typo or not. if it is then feel free to take this.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/scsi/qla4xxx/ql4_isr.c |    2 +-
>  drivers/scsi/qla4xxx/ql4_os.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
> index 6ffbe97..03e028e 100644
> --- a/drivers/scsi/qla4xxx/ql4_isr.c
> +++ b/drivers/scsi/qla4xxx/ql4_isr.c
> @@ -1027,7 +1027,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
>  					((ddb_entry->default_time2wait +
>  					  4) * HZ);
>  
> -				DEBUG2(printk("scsi%ld: ddb [%d] initate"
> +				DEBUG2(printk("scsi%ld: ddb [%d] initiate"
>  					      " RELOGIN after %d seconds\n",
>  					      ha->host_no,
>  					      ddb_entry->fw_ddb_index,
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 3fc1d25..967836e 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -812,7 +812,7 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
>  					);
>  				start_dpc++;
>  				DEBUG(printk("scsi%ld:%d:%d: ddb [%d] "
> -					     "initate relogin after"
> +					     "initiate relogin after"
>  					     " %d seconds\n",
>  					     ha->host_no, ddb_entry->bus,
>  					     ddb_entry->target,

As it's not in linux-next as of today, I'll be picking it up.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
