Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab1CXHjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:39:17 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:62412 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab1CXHjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:39:15 -0400
Date: Thu, 24 Mar 2011 03:39:07 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] APM: delete APM in Linux-2.6.40
In-reply-to: <20110324154505.934a56a0.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.02.1103240336590.4529@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index b3f35e5..2a03c46 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -619,3 +619,11 @@ Why:	The original implementation of memsw feature enabled by
 Who:	Michal Hocko <mhocko@suse.cz>
 
 ----------------------------
+
+What:	CONFIG_APM
+When:	2.6.40
+Why:	Microsoft deleted APM from Windows as of Vista in in 2006.
+	It now seems more than safe that the latest Linux Kernel be APM-free.
+	The vintage laptops supporting APM are now difficult to find,
+	making it problatic to maintain this code.
+Who:	Len Brown <len.brown@intel.com>
-- 
1.7.4.1.343.ga91df

