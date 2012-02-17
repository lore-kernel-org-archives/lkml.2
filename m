Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2BQJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:25:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50557 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2BQJZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:25:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Feb 2012 18:24:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 0/6] page cgroup diet v5
Message-Id: <20120217182426.86aebfde.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set is for removing 2 flags PCG_FILE_MAPPED and PCG_MOVE_LOCK on
page_cgroup->flags. After this, page_cgroup has only 3bits of flags.
And, this set introduces a new method to update page status accounting per memcg.
With it, we don't have to add new flags onto page_cgroup if 'struct page' has
information. This will be good for avoiding a new flag for page_cgroup.

Fixed pointed out parts.
 - added more comments
 - fixed texts
 - removed redundant arguments.

Passed some tests on 3.3.0-rc3-next-20120216.

Thanks,
-Kame

