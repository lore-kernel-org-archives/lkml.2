Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1LGRco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:32:44 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56706 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756676Ab1LGRcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:32:42 -0500
Message-ID: <1323279162.1762.51.camel@joe2Laptop>
Subject: Re: [PATCH] scsi: mark some messages as INFO/WARNING/ERROR
From: Joe Perches <joe@perches.com>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Dec 2011 09:32:42 -0800
In-Reply-To: <1323276754-1744-1-git-send-email-teg@jklm.no>
References: <1323276754-1744-1-git-send-email-teg@jklm.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 17:52 +0100, Tom Gundersen wrote:
> This reduces the noice
[]
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
[]
> @@ -416,7 +416,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
>  		if (!in_interrupt())
>  			sr_set_blocklength(cd, 2048);
>  		else
> -			printk("sr: can't switch blocksize: in interrupt\n");
> +			printk(KERN_WARNING "sr: can't switch blocksize: in interrupt\n");

Maybe this should be KERN_ERR?


