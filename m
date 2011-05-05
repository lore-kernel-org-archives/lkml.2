Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1EEP7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:59:37 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:37355 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751913Ab1EEP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:59:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dkY4mRIKzlWPB5hsaZPykVzrjfkdEbxaCYDrDP9ZZrlA8oh6CrrY9Oi9jRPtsz9rTCVCalJSexiVhRJttriW+NbFovuORQ8JNUN0zHWJj+OyHyNY5+XsEkQ8NESVzldm;
Message-ID: <4DC2C963.3040502@tao.ma>
Date: Thu, 05 May 2011 23:59:31 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: Re: [PATCH] block: Remove 'plug/unplug' comment in blk_execute_rq_nowait.
References: <1303746918-11097-1-git-send-email-tm@tao.ma>
In-Reply-To: <1303746918-11097-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.47.127 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,
	Is it ok to be merged?
On 04/25/2011 11:55 PM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> unplug is replaced with blk_run_queue now in blk_execute_rq_nowait,
> so change the comment accordingly.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  block/blk-exec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index 81e3181..d36bfbb 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -56,7 +56,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
>  	spin_lock_irq(q->queue_lock);
>  	__elv_add_request(q, rq, where);
>  	__blk_run_queue(q);
> -	/* the queue is stopped so it won't be plugged+unplugged */
> +	/* the queue is stopped so it won't be runned */
>  	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
>  		q->request_fn(q);
>  	spin_unlock_irq(q->queue_lock);

