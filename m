Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1BGXJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:09:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab1BGXJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:09:38 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] [PATCH] Clarify source code distribution requirements
Date: Mon,  7 Feb 2011 18:09:04 -0500
Message-Id: <1297120144-2142-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.203
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some vendors (such as http://users.livejournal.com/joshua_/43185.html)
insist that since section 3(b) of GPLv2 does not contain an explicit
timeframe for source distribution, they can ignore requests for source
for up to 120 days. Clarify the introduction to the license to indicate
that this isn't what's meant.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 COPYING |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/COPYING b/COPYING
index ca442d3..4cda18e 100644
--- a/COPYING
+++ b/COPYING
@@ -10,6 +10,12 @@
  is concerned is _this_ particular version of the license (ie v2, not
  v2.2 or v3.x or whatever), unless explicitly otherwise stated.
 
+ While this version of the GPL does not place an explicit timeframe
+ upon fulfilment of source distribution under section 3(b), it is the
+ consensus viewpoint of the Linux community that such distribution
+ take place as soon as is practical and certainly no more than 14 days
+ after a request is made.
+
 			Linus Torvalds
 
 ----------------------------------------
-- 
1.7.4

