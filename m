Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1IMKYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:24:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38969 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1IMKYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:24:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Sep 2011 19:23:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 03/11] mm: vmscan: distinguish between memcg triggering
 reclaim and memcg being scanned
Message-Id: <20110913192325.9f675d8d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315825048-3437-4-git-send-email-jweiner@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
	<1315825048-3437-4-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 12:57:20 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Memory cgroup hierarchies are currently handled completely outside of
> the traditional reclaim code, which is invoked with a single memory
> cgroup as an argument for the whole call stack.
> 
> Subsequent patches will switch this code to do hierarchical reclaim,
> so there needs to be a distinction between a) the memory cgroup that
> is triggering reclaim due to hitting its limit and b) the memory
> cgroup that is being scanned as a child of a).
> 
> This patch introduces a struct mem_cgroup_zone that contains the
> combination of the memory cgroup and the zone being scanned, which is
> then passed down the stack instead of the zone argument.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> 

