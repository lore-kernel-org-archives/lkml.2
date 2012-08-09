Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2HIGzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:55:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34659 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2HIGzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:55:11 -0400
Date: Wed, 8 Aug 2012 23:55:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 10/12] block: Add bio_clone_kmalloc()
Message-ID: <20120809065504.GE2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-11-git-send-email-koverstreet@google.com>
 <20120808231552.GJ6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809015704.GI7262@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809015704.GI7262@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 06:57:04PM -0700, Kent Overstreet wrote:
> That means bio_clone_kmalloc will just become:
> 
> static inline struct bio *bio_clone_kmalloc(struct bio *bio,
> 					    gfp_t gfp_mask)
> {
> 	return bio_clone_bioset(bio, gfp_mask, BIO_KMALLOC_POOL)
> }
> 
> (or maybe NULL there, I think using NULL for the interface makes sense,
> I just don't want to use it for bi_pool).
> 
> Do you still want the /** for a one line wrapper like that?

I don't know.  But do you think you can do similar thing to alloc
interface too?

Thanks.

-- 
tejun
