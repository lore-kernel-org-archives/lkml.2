Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2ITX7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:59:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51647 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2ITX7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:59:30 -0400
X-Greylist: delayed 21945 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2012 19:59:30 EDT
Date: Thu, 20 Sep 2012 16:59:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 11/26] raid10: Use bio_reset()
Message-ID: <20120920235925.GR7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-12-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-12-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:22PM -0700, Kent Overstreet wrote:
> More prep work for immutable bio vecs, mainly getting rid of references
> to bi_idx.
> 
> bio_reset was being open coded in a few places. The one in sync_request
> was a bit nontrivial to convert, so could use some extra eyeballs.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>

No idea at all.  Neil?

Thanks.

-- 
tejun
