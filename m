Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1KXL1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:27:32 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42611 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1KXL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:27:30 -0500
Message-ID: <1322134046.25125.35.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] clockevents: drop unknown Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 24 Nov 2011 12:27:26 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no Kconfig symbol GENERIC_CLOCKEVENTS_MIGR, so the check for it
will always fail.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Added in commit de68d9b173 ("clockevents: Allow build w/o run-tine usage
for migration purposes"), and part of mainline since v2.6.24, but it
looks like it's always been unknown.

 kernel/time/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index b26c222..2cf9cc7 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -25,7 +25,7 @@ config HIGH_RES_TIMERS
 config GENERIC_CLOCKEVENTS_BUILD
 	bool
 	default y
-	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
+	depends on GENERIC_CLOCKEVENTS
 
 config GENERIC_CLOCKEVENTS_MIN_ADJUST
 	bool
-- 
1.7.7.3

