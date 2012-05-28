Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2E1BPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 21:15:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50302 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2E1BPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 21:15:38 -0400
Date: Mon, 28 May 2012 10:15:22 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 01/16] block: Generalized bio pool freeing
Message-ID: <20120528011522.GA9891@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-2-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337977539-16977-2-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Fri, May 25, 2012 at 01:25:24PM -0700, Kent Overstreet wrote:
> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Change-Id: I5eb66c1d6910757f4af8755b8857dcbe4619cf8d

In the previous review, I made two requests about this patch.

* Please improve description.

* Please lose Change-Id.

None of which seems to have happened and my Acked-by isn't added
either.  Come on.  Give me some reason to keep reviewing this stuff.
A couple more suggestions.

* If this goes in, it will go through Jens' block tree.  Better keep
  him cc'd.

* It's generally a good idea to have Cc: tags in the description
  footer for the maintainers of the affected subsystems.

Thanks.

-- 
tejun
