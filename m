Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab2ERPzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:55:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36997 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2ERPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:55:43 -0400
Date: Fri, 18 May 2012 08:55:38 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 01/13] block: Generalized bio pool freeing
Message-ID: <20120518155538.GA19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <ea774fea2a27c9f1028a12ce31a7ee5e5517bef4.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea774fea2a27c9f1028a12ce31a7ee5e5517bef4.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:59:48PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Please add Cc: to maintainers of each modified subsystem.  Other than
that, nice cleanup even without the later removal of bi_destructor.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
