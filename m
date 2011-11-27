Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1K0Fjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:39:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808Ab1K0Fjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:39:43 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [PATCH 62/62] feature-removal-schedule.txt: add the deprecated form of kmap_atomic()
Date: Sun, 27 Nov 2011 13:27:42 +0800
Message-Id: <1322371662-26166-63-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Schedule the final removal to 3.5.

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3d84912..65aef30 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -551,3 +551,11 @@ When:	3.5
 Why:	The iwlagn module has been renamed iwlwifi.  The alias will be around
 	for backward compatibility for several cycles and then dropped.
 Who:	Don Fry <donald.h.fry@intel.com>
+
+----------------------------
+
+What:	kmap_atomic(page, km_type)
+When:	3.5
+Why:	The old kmap_atomic() with two arguments is deprecated, we only
+	keep it for backward compatibility for few cycles and then drop it.
+Who:	Cong Wang <amwang@redhat.com>
-- 
1.7.4.4

