Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0IDDR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 23:17:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316Ab0IDDR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 23:17:26 -0400
Date: Fri, 3 Sep 2010 20:21:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after
 direct reclaim allocation fails
Message-Id: <20100903202101.f937b0bb.akpm@linux-foundation.org>
In-Reply-To: <20100904022545.GD705@dastard>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
	<1283504926-2120-4-git-send-email-mel@csn.ul.ie>
	<20100903160026.564fdcc9.akpm@linux-foundation.org>
	<20100904022545.GD705@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010 12:25:45 +1000 Dave Chinner <david@fromorbit.com> wrote:

> Still, given the improvements in performance from this patchset,
> I'd say inclusion is a no-braniner....

OK, thanks.

It'd be interesting to check the IPI frequency with and without -
/proc/interrupts "CAL" field.  Presumably it went down a lot.

I wouldn't bust a gut over it though :)
