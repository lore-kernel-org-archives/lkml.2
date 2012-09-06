Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab2IFVB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:01:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52226 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab2IFVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:01:56 -0400
Date: Thu, 6 Sep 2012 14:01:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 2/8] block: Ues bi_pool for bio_integrity_alloc()
Message-ID: <20120906210152.GO29092@google.com>
References: <1346876849-15820-1-git-send-email-koverstreet@google.com>
 <1346876849-15820-3-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346876849-15820-3-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a typo in $SUBJ.

On Wed, Sep 05, 2012 at 01:27:23PM -0700, Kent Overstreet wrote:
> Now that bios keep track of where they were allocated from,
> bio_integrity_alloc_bioset() becomes redundant.

+ Remove bio_integrity_alloc_bioset() and drop bio_set argument from
+ the related functions and make them use bio->bi_pool.

> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
