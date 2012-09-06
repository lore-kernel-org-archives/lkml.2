Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2IFXsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:48:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab2IFXsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:48:09 -0400
Date: Thu, 6 Sep 2012 16:48:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v10 0/8] Block cleanups
Message-ID: <20120906234805.GD9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346970902-10931-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

(cc'ing Jens, Alasdair and Neil)

On Thu, Sep 06, 2012 at 03:34:54PM -0700, Kent Overstreet wrote:
> Screwed up the bio_reset() patch in the last patch series when I went to edit
> the description, fixed that here.
> 
> Only other change is the dm patch - made the front_pad conditional on
> DM_TYPE_BIO_BASED.
> 
> Kent Overstreet (8):
>   block: Generalized bio pool freeing
>   block: Ues bi_pool for bio_integrity_alloc()
>   dm: Use bioset's front_pad for dm_rq_clone_bio_info
>   block: Add bio_reset()
>   pktcdvd: Switch to bio_kmalloc()
>   block: Kill bi_destructor
>   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
>   block: Add bio_clone_bioset(), bio_clone_kmalloc()

This series looks good to me now.  If someone can ack the dm patch, I
think it's good to go.  Jens, what do you think?

Thanks.

-- 
tejun
