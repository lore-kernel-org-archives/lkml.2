Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2EaHZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:25:13 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34134 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2EaHZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:25:12 -0400
Date: Thu, 31 May 2012 09:25:05 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20120531072505.GA1371@cmpxchg.org>
References: <20120531141329.6f82889bcfaa30ca83a30937@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531141329.6f82889bcfaa30ca83a30937@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 02:13:29PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> mm/memcontrol.c between commit 78ccf5b5ab83 ("mm: memcg: print statistics
> directly to seq_file") and others from Linus' tree and commit "memcg: add
> mlock statistic in memory.stat" from the akpm tree.
> 
> I just dropped the akpm patch for now.

Thanks, Stephen.

However, the patch is known to be broken and, according to mm-commits,
was removed from -mm on May 16 already.  How'd it reappear?
