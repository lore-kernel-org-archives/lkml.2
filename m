Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1ILPJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:09:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab1ILPJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:09:49 -0400
Date: Mon, 12 Sep 2011 11:09:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/2] block: refactor generic_make_request
Message-ID: <20110912150935.GA27453@redhat.com>
References: <20110911145053.GA28996@infradead.org>
 <20110912134202.GA22953@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912134202.GA22953@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 09:42:02AM -0400, Christoph Hellwig wrote:

[..]
> +
>  	/* following loop may be a bit non-obvious, and so deserves some
>  	 * explanation.
>  	 * Before entering the loop, bio->bi_next is NULL (as all callers
> @@ -1557,16 +1561,15 @@ void generic_make_request(struct bio *bi
>  	 * from the top.  In this case we really did just take the bio
>  	 * of the top of the list (no pretending) and so remove it from
>  	 * bio_list, and call into __generic_make_request again.
                                   ^^^^^^^^^^
You got rid of __generic_make_request(). Now above comment has stale
reference to it.

Thanks
Vivek
