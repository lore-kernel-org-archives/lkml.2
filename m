Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1JUMZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:25:53 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42217 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1JUMZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:25:51 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 3/3] PM, Freezer,
 Docs: Update documentation about the new freezer notifiers
To: a.p.zijlstra@chello.nl
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
Date: Fri, 21 Oct 2011 17:55:41 +0530
Message-ID: <20111021122528.14321.58732.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111021122401.14321.45857.stgit@srivatsabhat.in.ibm.com>
References: <20111021122401.14321.45857.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11102102-5140-0000-0000-000000189452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/notifiers.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/notifiers.txt b/Documentation/power/notifiers.txt
index c2a4a34..f47fe30 100644
--- a/Documentation/power/notifiers.txt
+++ b/Documentation/power/notifiers.txt
@@ -37,6 +37,14 @@ PM_POST_SUSPEND		The system has just resumed or an error occurred during
 			suspend.  Device drivers' resume callbacks have been
 			executed and tasks have been thawed.
 
+PM_FREEZE_PREPARE	Freezing of tasks is about to begin.
+
+PM_POST_FREEZE		Freezing of tasks has been completed.
+
+PM_THAW_PREPARE   	Thawing of tasks is about to begin.
+
+PM_POST_THAW     	Thawing of tasks has been completed.
+
 It is generally assumed that whatever the notifiers do for
 PM_HIBERNATION_PREPARE, should be undone for PM_POST_HIBERNATION.  Analogously,
 operations performed for PM_SUSPEND_PREPARE should be reversed for

