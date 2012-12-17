Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2LQSNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:13:37 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36555 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab2LQSNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:13:36 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/8] page reclaim bits v2
Date: Mon, 17 Dec 2012 13:12:30 -0500
Message-Id: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I dropped the controversial change of the meaning of !swappiness for
memcg and instead made the two changes into one cleanup patch to spell
out the conditions in get_scan_count() more explicitely.

Aside from that, I expanded the changelogs with statistics and numbers
where there was confusion about the benefits and added the review tags
to the patches that didn't otherwise change.  Let me know if I missed
any review feedback, but I think I have it all addressed.

Thanks!

