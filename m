Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2IGUoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:44:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab2IGUoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:44:21 -0400
Date: Fri, 7 Sep 2012 13:44:18 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v10 0/8] Block cleanups
Message-ID: <20120907204418.GC16360@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <20120906234805.GD9426@google.com>
 <50494FC6.3050502@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50494FC6.3050502@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 07:37:10PM -0600, Jens Axboe wrote:
> On 2012-09-06 17:48, Tejun Heo wrote:
> > Hello, guys.
> > 
> > (cc'ing Jens, Alasdair and Neil)
> > 
> > On Thu, Sep 06, 2012 at 03:34:54PM -0700, Kent Overstreet wrote:
> >> Screwed up the bio_reset() patch in the last patch series when I went to edit
> >> the description, fixed that here.
> >>
> >> Only other change is the dm patch - made the front_pad conditional on
> >> DM_TYPE_BIO_BASED.
> >>
> >> Kent Overstreet (8):
> >>   block: Generalized bio pool freeing
> >>   block: Ues bi_pool for bio_integrity_alloc()
> >>   dm: Use bioset's front_pad for dm_rq_clone_bio_info
> >>   block: Add bio_reset()
> >>   pktcdvd: Switch to bio_kmalloc()
> >>   block: Kill bi_destructor
> >>   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
> >>   block: Add bio_clone_bioset(), bio_clone_kmalloc()
> > 
> > This series looks good to me now.  If someone can ack the dm patch, I
> > think it's good to go.  Jens, what do you think?
> 
> Looks OK to me too. I'll run a quick perf test on this tomorrow, and get
> it queued up for 3.7 if it looks fine.

Thanks!

> Kent, are to resend 3+5 to me?

You should have it now.
