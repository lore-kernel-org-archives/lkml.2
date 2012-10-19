Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab2JSUgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:36:13 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:43615 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2JSUgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:36:10 -0400
Date: Fri, 19 Oct 2012 13:36:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 01/26] block: Convert integrity to bvec_alloc_bs(),
 and a bugfix
Message-ID: <20121019203606.GU13370@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-31-git-send-email-koverstreet@google.com>
 <20121019203421.GT13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019203421.GT13370@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 01:34:21PM -0700, Tejun Heo wrote:
> On Mon, Oct 15, 2012 at 01:09:04PM -0700, Kent Overstreet wrote:
> > This adds a pointer to the bvec array to struct bio_integrity_payload,
> > instead of the bvecs always being inline; then the bvecs are allocated
> > with bvec_alloc_bs().
> > 
> > This is needed eventually for immutable bio vecs - immutable bvecs
> > aren't useful if we still have to copy them, hence the need for the
> > pointer. Less code is always nice too, though.
> > 
> > Also fix an amusing bug in bio_integrity_split() - struct bio_pair
> > doesn't have the integrity bvecs after the bio_integrity_payloads, so
> > there was a buffer overrun. The code was confusing pointers with arrays.
> 
> Ummm... patch description doesn't agree with the patch content?

And the patch posted doesn't match the commit in git branch.

Dazed and confused.  Bailing out.  Let's retry next time.

-- 
tejun
