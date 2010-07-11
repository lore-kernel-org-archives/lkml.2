Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0GKTlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 15:41:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0GKTlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 15:41:42 -0400
Date: Sun, 11 Jul 2010 21:41:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] trivial: fix typos concerning "sequential"
In-Reply-To: <1278010125-20191-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1007112141310.4741@pobox.suse.cz>
References: <1278010125-20191-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Uwe Kleine-König wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/media/video/gspca/sunplus.c |    4 ++--
>  include/linux/jffs2.h               |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/gspca/sunplus.c b/drivers/media/video/gspca/sunplus.c
> index 0c786e0..d0a133a 100644
> --- a/drivers/media/video/gspca/sunplus.c
> +++ b/drivers/media/video/gspca/sunplus.c
> @@ -805,7 +805,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
>  			/* Set AE AWB Banding Type 3-> 50Hz 2-> 60Hz */
>  			spca504A_acknowledged_command(gspca_dev, 0x24,
>  							8, 3, 0x9e, 1);
> -			/* Twice sequencial need status 0xff->0x9e->0x9d */
> +			/* Twice sequential need status 0xff->0x9e->0x9d */
>  			spca504A_acknowledged_command(gspca_dev, 0x24,
>  							8, 3, 0x9e, 0);
>  
> @@ -880,7 +880,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
>  			/* Set AE AWB Banding Type 3-> 50Hz 2-> 60Hz */
>  			spca504A_acknowledged_command(gspca_dev, 0x24,
>  							8, 3, 0x9e, 1);
> -			/* Twice sequencial need status 0xff->0x9e->0x9d */
> +			/* Twice sequential need status 0xff->0x9e->0x9d */
>  			spca504A_acknowledged_command(gspca_dev, 0x24,
>  							8, 3, 0x9e, 0);
>  			spca504A_acknowledged_command(gspca_dev, 0x24,
> diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
> index 0874ab5..edb9231 100644
> --- a/include/linux/jffs2.h
> +++ b/include/linux/jffs2.h
> @@ -185,7 +185,7 @@ struct jffs2_raw_xref
>  	jint32_t hdr_crc;
>  	jint32_t ino;		/* inode number */
>  	jint32_t xid;		/* XATTR identifier number */
> -	jint32_t xseqno;	/* xref sequencial number */
> +	jint32_t xseqno;	/* xref sequential number */
>  	jint32_t node_crc;
>  } __attribute__((packed));

Applied, thank you Uwe.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
