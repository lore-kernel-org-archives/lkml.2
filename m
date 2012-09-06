Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2IFXqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56369 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2IFXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:46:08 -0400
Date: Thu, 6 Sep 2012 16:46:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v10 8/8] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Message-ID: <20120906234603.GC9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-9-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346970902-10931-9-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:35:02PM -0700, Kent Overstreet wrote:
> Previously, there was bio_clone() but it only allocated from the fs bio
> set; as a result various users were open coding it and using
> __bio_clone().
> 
> This changes bio_clone() to become bio_clone_bioset(), and then we add
> bio_clone() and bio_clone_kmalloc() as wrappers around it, making use of
> the functionality the last patch adedd.
> 
> This will also help in a later patch changing how bio cloning works.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>
> CC: Alasdair Kergon <agk@redhat.com>
> CC: Boaz Harrosh <bharrosh@panasas.com>
> CC: Jeff Garzik <jeff@garzik.org>
> Acked-by: Jeff Garzik <jgarzik@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
