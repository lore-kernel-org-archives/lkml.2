Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1KFCOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 22:14:36 -0400
Received: from mta21.charter.net ([216.33.127.81]:63960 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1KFCOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 22:14:31 -0400
X-Authority-Analysis: v=1.1 cv=3kn4snR/2TdwuYXvh+wm0CPnSGzQFWY7ukd303aPFv0=
 c=1 sm=1 a=0LignYgg2xsA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=D19gQVrFAAAA:8 a=HoPpDHSOP-ic3xvwFngA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Gregory.Dietsche@cuw.edu
To: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        mmarek@suse.cz
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [RESEND 0/3] coccinelle: add parallel execution
Date: Sat,  5 Nov 2011 21:14:10 -0500
Message-Id: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

This is a re-post of the patches found here: https://lkml.org/lkml/2011/7/12/397

Could I get the appropriate aks/naks to get these into the kernel? Also, I've added Michal Marek to the CC list since it is my understanding that he's the one that will eventually commit these. Thanks!!

---

This patch series adds a new flag PARALLEL= to the coccicheck build target and documents the new feature.

Performance is quite a bit better than single threaded. On my 6 core box, the checks generally run around 3x faster.


Greg Dietsche (3):
  coccinelle.txt: add overview section
  coccinelle.txt: add documentation of PARALLEL= flag
  coccicheck: add parallel execution

 Documentation/coccinelle.txt |   35 +++++++++++++++++++++++++++++++++++
 scripts/coccicheck           |   27 ++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletions(-)

-- 
1.7.6.4

