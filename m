Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1GHTEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:04:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60182 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab1GHTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:04:13 -0400
Message-ID: <4E17549D.5000006@gmail.com>
Date: Fri, 08 Jul 2011 12:03:57 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/3]drivers:scsi:qla2xxx:qla_isr.c Typo fix hammmer.
References: <1308896549-4560-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1308896549-4560-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jiri,
not sure if you git these, adding you to the Cc's list

> From: "Justin P. Mattock"<justinmattock@gmail.com>
>
> The below patch fixes a typo.
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 1b60a95..ae8e298 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -63,7 +63,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>
>   			/*
>   			 * Issue a "HARD" reset in order for the RISC interrupt
> -			 * bit to be cleared.  Schedule a big hammmer to get
> +			 * bit to be cleared.  Schedule a big hammer to get
>   			 * out of the RISC PAUSED state.
>   			 */
>   			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
> @@ -169,7 +169,7 @@ qla2300_intr_handler(int irq, void *dev_id)
>   			/*
>   			 * Issue a "HARD" reset in order for the RISC
>   			 * interrupt bit to be cleared.  Schedule a big
> -			 * hammmer to get out of the RISC PAUSED state.
> +			 * hammer to get out of the RISC PAUSED state.
>   			 */
>   			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
>   			RD_REG_WORD(&reg->hccr);

