Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1G0UOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:14:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525Ab1G0UO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:14:28 -0400
Date: Wed, 27 Jul 2011 13:14:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 08/10] ilru: reduce zone->lru_lock
Message-Id: <20110727131405.0b663296.akpm@linux-foundation.org>
In-Reply-To: <100bcc5d254e5e88f91356876b1d2ce463c2309e.1309787991.git.minchan.kim@gmail.com>
References: <cover.1309787991.git.minchan.kim@gmail.com>
	<100bcc5d254e5e88f91356876b1d2ce463c2309e.1309787991.git.minchan.kim@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Jul 2011 23:04:41 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> inorder_lru increases zone->lru_lock overhead(pointed out by Mel)
> as it doesn't support pagevec.
> This patch introduces ilru_add_pvecs and APIs.

aww geeze, this patch goes and deletes most of the code I just reviewed!

Can we fold them please?
