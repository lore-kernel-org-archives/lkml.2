Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2BHOK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:10:58 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:50395
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751591Ab2BHOK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:10:57 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-mm@kvack.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mm: Fix typo in cleancache.txt
Date: Wed,  8 Feb 2012 23:10:14 +0900
Message-Id: <1328710214-3185-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "implementatation" to "implementation" in
Documentation/vm/cleancache.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/vm/cleancache.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/cleancache.txt b/Documentation/vm/cleancache.txt
index f726717..142fbb0 100644
--- a/Documentation/vm/cleancache.txt
+++ b/Documentation/vm/cleancache.txt
@@ -93,7 +93,7 @@ failed_gets	- number of gets that failed
 puts		- number of puts attempted (all "succeed")
 invalidates	- number of invalidates attempted
 
-A backend implementatation may provide additional metrics.
+A backend implementation may provide additional metrics.
 
 FAQ
 
-- 
1.7.6.5

