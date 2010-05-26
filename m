Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab0EZJ6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:58:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60710 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab0EZJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:58:08 -0400
Date: Wed, 26 May 2010 11:58:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 1/7] hugetlb, rmap: add reverse mapping for hugepage
Message-ID: <20100526095805.GB24615@basil.fritz.box>
References: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1273737326-21211-2-git-send-email-n-horiguchi@ah.jp.nec.com> <20100513152737.GE27949@csn.ul.ie> <20100514074641.GD10000@spritzerA.linux.bs1.fc.nec.co.jp> <20100514095449.GB21481@csn.ul.ie> <20100524071516.GC11008@spritzerA.linux.bs1.fc.nec.co.jp> <20100525105957.GD29038@csn.ul.ie> <20100526065156.GC7128@spritzerA.linux.bs1.fc.nec.co.jp> <20100526091958.GA24615@basil.fritz.box> <20100526094442.GK29038@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526094442.GK29038@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:44:43AM +0100, Mel Gorman wrote:
> On Wed, May 26, 2010 at 11:19:58AM +0200, Andi Kleen wrote:
> > 
> > Mel, other than this nit are you happy with these changes now?
> > 
> 
> Pretty much but I also want to test the series myself to be sure I haven't
> missed something in review.

Thanks. I'll wait a bit more and if there is no negative reviews
I'll start queueing it in the hwpoison tree.

I should add this is probably only the first step, "early kill" support
and soft offline might need some more mm changes.

-Andi
