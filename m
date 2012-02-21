Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2BUIJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:09:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55351 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2BUIJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:09:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Feb 2012 17:08:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/10] mm/memcg: add zone pointer into lruvec
Message-Id: <20120221170807.a5b961db.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202201529450.23274@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils>
	<alpine.LSU.2.00.1202201529450.23274@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 15:30:45 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> The lruvec is looking rather useful: if we just add a zone pointer
> into the lruvec, then we can pass the lruvec pointer around and save
> some superfluous arguments and recomputations in various places.
> 
> Just occasionally we do want mem_cgroup_from_lruvec() to get back from
> lruvec to memcg; but then we can remove all uses of vmscan.c's private
> mem_cgroup_zone *mz, passing the lruvec pointer instead.
> 
> And while we're there, get_scan_count() can call vmscan_swappiness()
> once, instead of twice in a row.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---

I like this cleanup

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

