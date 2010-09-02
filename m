Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0IBVHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:07:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab0IBVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u8U+Z0FeCOrLnrlO+V/Hz9qp8CB5RnBNj/3kt+K8/1YBpS4MkOSjsl3zx10ABhgPnz
         /yI6oU3Q72kSUmBk1/L2zKOGAveenWHOw07qCMVBAFguwV5kvecMj5VqHgCwdT0ePmtP
         gcE5Pq1NbQyvLjbXKOPjpWFiZRKEtA33iP0ng=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 11/91] arch/arm/nwfpe/softfloat.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:42 -0700
Message-Id: <1283461606-7803-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/nwfpe/softfloat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/nwfpe/softfloat.c b/arch/arm/nwfpe/softfloat.c
index 0f9656e..21ddf55 100644
--- a/arch/arm/nwfpe/softfloat.c
+++ b/arch/arm/nwfpe/softfloat.c
@@ -11,8 +11,8 @@ National Science Foundation under grant MIP-9311980.  The original version
 of this code was written as part of a project to build a fixed-point vector
 processor in collaboration with the University of California at Berkeley,
 overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
-is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
-arithmetic/softfloat.html'.
+is available through the web page `http://www.jhauser.us/arithmetic/
+SoftFloat-2b/SoftFloat-source.txt'.
 
 THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
 has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
-- 
1.7.2.1

