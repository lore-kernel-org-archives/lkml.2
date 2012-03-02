Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2CBFPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:15:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42802 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2CBFPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:15:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Mar 2012 14:14:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] mm/memcg: move reclaim_stat into lruvec
Message-Id: <20120302141405.cf0f2f51.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120229091543.29236.90823.stgit@zurg>
References: <20120229090748.29236.35489.stgit@zurg>
	<20120229091543.29236.90823.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 13:15:43 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> From: Hugh Dickins <hughd@google.com>
> 
> With mem_cgroup_disabled() now explicit, it becomes clear that the
> zone_reclaim_stat structure actually belongs in lruvec, per-zone
> when memcg is disabled but per-memcg per-zone when it's enabled.
> 
> We can delete mem_cgroup_get_reclaim_stat(), and change
> update_page_reclaim_stat() to update just the one set of stats,
> the one which get_scan_count() will actually use.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

