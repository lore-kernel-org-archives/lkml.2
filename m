Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0GUFGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:06:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61571 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762306Ab0GUE6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fq6KAdKyqYOUE/pOr69nvAU08EaaETG7mDwQPJlku+A+kbDzdPwr5NZ859zKwaMNAG
         pgCcWZx/hdZkImZvl82butJpDEc15xUWqwhjdEXrc3OpcczWfmdoApSGPzZXnYHjHmRs
         VNljg8RT6/YxvV9Uy3P8m8vF19xG1A11B09Pk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 116/116]Documentation/telephony/ixj.txt update web address.
Date: Tue, 20 Jul 2010 21:57:55 -0700
Message-Id: <1279688279-29683-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes a web address due to me unable to get it
to work(either the company is sleeping, or there just hosting
words during a search). And also update broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/telephony/ixj.txt |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/Documentation/telephony/ixj.txt b/Documentation/telephony/ixj.txt
index 44d1240..f314b46 100644
--- a/Documentation/telephony/ixj.txt
+++ b/Documentation/telephony/ixj.txt
@@ -108,14 +108,9 @@ applications.
 
 1.4  Where to get things
 
-You can download the latest versions of the driver from:
-
-http://www.quicknet.net/develop.htm
-
-You can download the latest version of this document from:
-
-http://www.quicknet.net/develop.htm
+Information about his here:
 
+http://www.kernel.org/pub/linux/kernel/people/marcelo/linux-2.4/Documentation/telephony/ixj.txt
 
 1.5  Mailing List
 
@@ -172,11 +167,11 @@ module to autoconfigure them.  The former package probably came with
 your Linux distribution.  Documentation on this package is available
 online at:
 
-http://mailer.wiwi.uni-marburg.de/linux/LDP/HOWTO/Plug-and-Play-HOWTO.html
+http://tldp.org/HOWTO/Plug-and-Play-HOWTO.html
 
 The isapnp autoconfiguration is available on the Quicknet website at:
 
-    http://www.quicknet.net/develop.htm
+    http://www.kernel.org/pub/linux/kernel/people/marcelo/linux-2.4/Documentation/isapnp.txt
 
 though it may be in the kernel by the time you read this.
 
-- 
1.7.1.rc1.21.gf3bd6

