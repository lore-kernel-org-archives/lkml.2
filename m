Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab1LGXOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:14:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49197 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab1LGXOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:14:17 -0500
Date: Wed, 7 Dec 2011 15:11:23 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [PATCH] docs: additional LWN links to RCU API
Message-ID: <20111207231123.GA13371@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tyler Hicks pointed me at an additional article on RCU and I figured
it should probably be mentioned with the others.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/RCU/whatisRCU.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 6ef6926..f0c5750 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -4,6 +4,7 @@ to start learning about RCU:
 1.	What is RCU, Fundamentally?  http://lwn.net/Articles/262464/
 2.	What is RCU? Part 2: Usage   http://lwn.net/Articles/263130/
 3.	RCU part 3: the RCU API      http://lwn.net/Articles/264090/
+4.	The RCU API, 2010 Edition    http://lwn.net/Articles/418853/
 
 
 What is RCU?
-- 
1.7.0.4

