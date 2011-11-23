Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab1KWIE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:04:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45809 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1KWIE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:04:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Nov 2011 17:03:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton (commit_signer:71/87=82%) 
	<akpm@linux-foundation.org>,
        Mel Gorman (commit_signer:39/87=45%) <mgorman@suse.de>,
        Minchan Kim (commit_signer:32/87=37%) <minchan.kim@gmail.com>,
        Johannes Weiner (commit_signer:21/87=24%) <jweiner@redhat.com>,
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] vmscan: add task name to warn_scan_unevictable()
 messages
Message-Id: <20111123170319.cc668d61.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
References: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 00:55:20 -0500
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> If we need to know a usecase, caller program name is critical important.
> Show it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
seems nice.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

