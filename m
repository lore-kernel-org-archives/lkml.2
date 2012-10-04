Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2JDSJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:38 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58770 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab2JDSJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] memcg fixups that fell through cracks in 3.5
Date: Thu,  4 Oct 2012 14:09:15 -0400
Message-Id: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

an older version of "mm: memcg: count pte references from every member
of the reclaimed hierarchy" patch made it into the 3.5
(c3ac9a8ade65ccbfd145fbff895ae8d8d62d09b0) by accident and I didn't
notice until just now.  #1 is a fixup on top, tagged for 3.5-stable.

#2 is a cleanup you requested but probably missed as it was attached
to a mail buried in the thread.  For 3.6.

Patches against mm.git.

