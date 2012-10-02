Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab2JBTYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab2JBTYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:24:45 -0400
Date: Tue, 2 Oct 2012 15:24:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk
Subject: Re: [dm-devel] [PATCH v3 09/26] block: Remove bi_idx references
Message-ID: <20121002192434.GE3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-10-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348526106-17074-10-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:34:49PM -0700, Kent Overstreet wrote:

[..]
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 95e52879..24e5cef 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -3778,7 +3778,6 @@ static int __floppy_read_block_0(struct block_device *bdev)
>  	bio_vec.bv_len = size;
>  	bio_vec.bv_offset = 0;
>  	bio.bi_vcnt = 1;
> -	bio.bi_idx = 0;

So leaving bio.bi_idx uninitialized is safer than setting it to zero? Can
you explain a bit more that why this change is required? 

Thanks
Vivek
