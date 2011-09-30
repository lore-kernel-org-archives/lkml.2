Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab1I3IGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:06:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38106 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1I3IGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:06:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Sep 2011 17:05:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] memcg naturalization -rc4
Message-Id: <20110930170510.4695b8f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317330064-28893-1-git-send-email-jweiner@redhat.com>
References: <1317330064-28893-1-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 23:00:54 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Hi,
> 
> this is the fourth revision of the memory cgroup naturalization
> series.
> 
> The changes from v3 have mostly been documentation, changelog, and
> naming fixes based on review feedback:
> 
>     o drop conversion of no longer existing zone-wide unevictable
>       page rescue scanner
>     o fix return value of mem_cgroup_hierarchical_reclaim() in
>       limit-shrinking mode (Michal)
>     o rename @remember to @reclaim in mem_cgroup_iter()
>     o convert vm_swappiness to global_reclaim() in the
>       correct patch (Michal)
>     o rename
>       struct mem_cgroup_iter_state -> struct mem_cgroup_reclaim_iter
>       and
>       struct mem_cgroup_iter -> struct mem_cgroup_reclaim_cookie
>       (Michal)
>     o added/amended comments and changelogs based on feedback (Michal, Kame)
> 
> Thanks for the review and feedback, guys, it's much appreciated!
> 

Thank you for your work. Now, I'm ok this series to be tested in -mm.
Ack. to all.

Do you have any plan, concerns ?

Thanks,
-Kame

