Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2BPOUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:20:30 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:47427
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2BPOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:20:29 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix typo in events-power.txt
Date: Thu, 16 Feb 2012 23:19:56 +0900
Message-Id: <1329401996-2244-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "Fequency" to "Frequency" in
Documentation/trace/events-power.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/trace/events-power.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
index 96d87b6..cf794af 100644
--- a/Documentation/trace/events-power.txt
+++ b/Documentation/trace/events-power.txt
@@ -57,7 +57,7 @@ power_end		"cpu_id=%lu"
 The 'type' parameter takes one of those macros:
  . POWER_NONE	= 0,
  . POWER_CSTATE	= 1,	/* C-State */
- . POWER_PSTATE	= 2,	/* Fequency change or DVFS */
+ . POWER_PSTATE	= 2,	/* Frequency change or DVFS */
 
 The 'state' parameter is set depending on the type:
  . Target C-state for type=POWER_CSTATE,
-- 
1.7.6.5

