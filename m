Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0IMTE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:04:59 -0400
Received: from daytona.panasas.com ([67.152.220.89]:57004 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754818Ab0IMTE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:04:58 -0400
Message-ID: <4C8E75D7.4010205@panasas.com>
Date: Mon, 13 Sep 2010 21:04:55 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Benny Halevy <bhalevy@panasas.com>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SQUASHME: pnfs-obj: fix REQ flags usage
References: <1284404221-3673-1-git-send-email-bhalevy@panasas.com>
In-Reply-To: <1284404221-3673-1-git-send-email-bhalevy@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Sep 2010 19:04:57.0580 (UTC) FILETIME=[8EB712C0:01CB5376]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch, pilot error...
I'll send the right one momentarily.

Benny

On 2010-09-13 20:57, Benny Halevy wrote:
> fixes "pnfs-obj use REQ flags rather than BIO flags"
> 
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  fs/nfs/objlayout/objio_osd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
> index 223980b..75d5df4 100644
> --- a/fs/nfs/objlayout/objio_osd.c
> +++ b/fs/nfs/objlayout/objio_osd.c
> @@ -910,7 +910,7 @@ static int _write_mirrors(struct objio_state *ios, unsigned cur_comp)
>  		} else {
>  			bio = master_dev->bio;
>  			/* FIXME: bio_set_dir() */
> -			bio->bi_rw |= (1 << REQ_WRITE);
> +			bio->bi_rw |= REQ_WRITE;
>  		}
>  
>  		osd_req_write(or, &obj, per_dev->offset, bio, per_dev->length);
