Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab0GBIaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:30:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42287 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0GBIa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:30:28 -0400
Date: Fri, 2 Jul 2010 10:30:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] hugepage migration
Message-ID: <20100702083026.GB12221@basil.fritz.box>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 02:47:19PM +0900, Naoya Horiguchi wrote:
> This is a patchset for hugepage migration.

Thanks for working on this.
> 
> There are many users of page migration such as soft offlining,
> memory hotplug, memory policy and memory compaction,
> but this patchset adds hugepage support only for soft offlining
> as the first step.

Is that simply because the callers are not hooked up yet 
for the other cases, or more fundamental issues?


> I tested this patchset with 'make func' in libhugetlbfs and
> have gotten the same result as one from 2.6.35-rc3.

Is there a tester for the functionality too? (e.g. mce-test test cases)

-Andi
