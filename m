Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1KFCN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 22:13:56 -0400
Received: from que21.charter.net ([209.225.8.22]:61724 "EHLO que21.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1KFCNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 22:13:54 -0400
X-Authority-Analysis: v=1.1 cv=3kn4snR/2TdwuYXvh+wm0CPnSGzQFWY7ukd303aPFv0=
 c=1 sm=1 a=gjzqeYHFQAwA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=D19gQVrFAAAA:8 a=L2xoN_Hgfg_jovWM_lQA:9 a=ktXrGBrjdUS4r1ek-0AA:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Gregory.Dietsche@cuw.edu
To: julia@diku.dk, mmarek@suse.cz
Cc: rdunlap@xenotime.net, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        cocci@diku.dk, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [RESEND 0/2] coccicheck: Add M= option
Date: Sat,  5 Nov 2011 20:59:42 -0500
Message-Id: <1320544784-24576-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

This is a re-post of the patches found here: https://lkml.org/lkml/2011/6/7/714

Could I get the appropriate aks/naks to get these into the kernel? Also, I've added Michal Marek to the CC list since it is my understanding that he's the one that will eventually commit these. Thanks!!

---

This patch set adds support for M= to coccicheck. This makes 
using Coccinelle easier for those wishing to check specific
drivers or sub systems with Coccinelle.

Greg Dietsche (2):
  coccicheck: add M= option to control which dir is processed
  coccinelle.txt: update documentation to include M= option

 Documentation/coccinelle.txt |   10 ++++++++--
 scripts/coccicheck           |   19 ++++++++++++++-----
 2 files changed, 22 insertions(+), 7 deletions(-)

-- 
1.7.6.4

