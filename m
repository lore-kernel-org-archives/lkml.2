Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1EAPDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:03:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49587 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1EAPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wn9ODBTWfHWRaIPh89dA6nPMO6N1UsEnudD90HAFL/9z7aofjmv6CIbQl/NkZxL6GO
         ZfeOeQbKiHKQM9CHwejxADbsaFMj3SQjqp4DJgmd2fCxT1j/mctLTGLCK4IgmeMv2VM2
         jhMU5dCXxUp2B799uuqIx5UkcVHQ6K4mLVp+M=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 0/2] Fix an enhance deactive_page
Date: Mon,  2 May 2011 00:03:29 +0900
Message-Id: <cover.1304261567.git.minchan.kim@gmail.com>
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


Minchan Kim (2):
  [1/2] Check PageUnevictable in lru_deactivate_fn
  [2/2] Filter unevictable page out in deactivate_page

 mm/swap.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

