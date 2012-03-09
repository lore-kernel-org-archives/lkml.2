Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2CIB2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:28:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44639 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2CIB2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:28:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 10:27:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] mm/memcg: move reclaim_stat into lruvec
Message-Id: <20120309102707.0a32cf45.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120308180405.27621.97346.stgit@zurg>
References: <20120308175752.27621.54781.stgit@zurg>
	<20120308180405.27621.97346.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 22:04:06 +0400
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
> 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

