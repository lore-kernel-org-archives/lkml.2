Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1CZSv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:51:29 -0400
Received: from mail.perches.com ([173.55.12.10]:4280 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab1CZSv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:51:28 -0400
Subject: Re: [PATCH 2/4] staging: keucr: smscsi: Includes missing KERN_
 facility level to printk().
From: Joe Perches <joe@perches.com>
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1301156180-12192-2-git-send-email-ralf.thielow@googlemail.com>
References: <1301156180-12192-1-git-send-email-ralf.thielow@googlemail.com>
	 <1301156180-12192-2-git-send-email-ralf.thielow@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 11:51:26 -0700
Message-ID: <1301165486.17567.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 17:16 +0100, Ralf Thielow wrote:
> Includes missing KERN_ facility level to printk().
[]
> diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
[]
> @@ -97,7 +97,7 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
>  	WORD bl_len;
>  	BYTE buf[8];
>  
> -	printk("SM_SCSI_Read_Capacity\n");
> +	printk(KERN_DEBUG, "SM_SCSI_Read_Capacity\n");

There should not be a comma between KERN_<level> and format.

Compile tested?

> +	printk(KERN_DEBUG, "bl_len = %x\n", bl_len);
> +	printk(KERN_DEBUG, "bl_num = %x\n", bl_num);


