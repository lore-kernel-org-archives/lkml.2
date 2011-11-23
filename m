Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab1KWHfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:35:17 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44373 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab1KWHfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:35:16 -0500
Date: Wed, 23 Nov 2011 08:34:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmscan: add task name to warn_scan_unevictable() messages
Message-ID: <20111123073455.GC11440@cmpxchg.org>
References: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:55:20AM -0500, KOSAKI Motohiro wrote:
> If we need to know a usecase, caller program name is critical important.
> Show it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Oops, yes, this could be one hell to track down otherwise.  Thanks.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
