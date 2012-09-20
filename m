Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2ITXt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:49:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37103 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2ITXt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:49:58 -0400
Date: Thu, 20 Sep 2012 16:49:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 08/26] block: Remove bi_idx references
Message-ID: <20120920234953.GO7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-9-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-9-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:19PM -0700, Kent Overstreet wrote:
> These were harmless but uneccessary,andt getting rid of them makes the
> code easier to audit since most of them need to be removed.

I find the descriptions a bit too terse.  Why do they need to be
removed?  So, I suppose you wanted to say explicit initializations to
0 are unnecessary, but there are bio_segments() conversions too.

The patch is simple and this isn't a big deal but I really hope for
better (correct) descriptions.

Thanks.

-- 
tejun
