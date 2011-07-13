Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1GMBZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 21:25:31 -0400
Received: from mta31.charter.net ([216.33.127.82]:44564 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1GMBZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 21:25:30 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=ZxubRnMw9rsA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=ov-54fNVy-oBpQBA2Z8A:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 0/3] coccinelle: add parallel execution
Date: Tue, 12 Jul 2011 20:26:42 -0500
Message-Id: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a new flag PARALLEL= to the coccicheck build target and documents the new feature.
It works a lot like make's -j flag. I looked for a way to have make pass on the value of -j, but
didn't find one - if anyone knows how to do that, I'd love to hear about it! 

I suppose an alternate approach would be to accomplish this via make itself, but the approach in this patch series seemed simpler to implement... 

Performance is quite a bit better than single threaded. On my 6 core box, the checks generally run around 3x faster.

Feedback welcome!! :)

Greg

Greg Dietsche (3):
  coccinelle.txt: add overview section
  coccinelle.txt: add documentation of PARALLEL= flag
  coccicheck: add parallel execution

 Documentation/coccinelle.txt |   35 +++++++++++++++++++++++++++++++++++
 scripts/coccicheck           |   27 ++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletions(-)

-- 
1.7.2.5

