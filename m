Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1ECOsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:48:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55811 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1ECOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V6pGFIbKtbLCSKtpjFsOJYyUTAWF+fAjfWGRE4enYdfD6EOklzmLdr6RvsLeqU+gxK
         /Q2GRpxBmcVkdgw3tvNmHuQ/5Xhpuv60vTjJkraZ77ZE6jw+yFJqhDtD7Hz1SV6zTPIY
         yRNhXeF/Kudv3+Oqichi3Gr61oKqxubilKkNA=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 0/2] Fix and Enhance deactive_page
Date: Tue,  3 May 2011 23:48:31 +0900
Message-Id: <cover.1304433952.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few days ago, Ying reported a problem.
http://marc.info/?l=linux-mm&m=130403310601663&w=2
After I and Ying dive in problem, We found deactive_page
has a problem. Apparently, It's a BUG so 
[1/2] is fix of the problem and [2/2] is enhancement for 
helping CPU.

* v2
  - add Reviewed-by signs
  - Fix typo

Minchan Kim (2):
  [1/2] Check PageUnevictable in lru_deactivate_fn
  [2/2] Filter unevictable page out in deactivate_page

 mm/swap.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

