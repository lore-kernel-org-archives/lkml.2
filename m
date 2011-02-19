Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1BSPoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 10:44:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60139 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1BSPn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 10:43:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XFpEsEOI/k3CBuoSkJQ3+JkCI+orHBvQv5bAsjjb7bN4nQ/RXwLIefNueImA7Vb+u/
         tjfXnD1HNSW4ahBK7cQ+D43sJW60im2s3xTUOefr/7HBXP8dg+5XoTNayP/NO/POoyT7
         kJTD1J3tPzg6gynEhY2rqc3v8NbneKe0G7ayQ=
Date: Sat, 19 Feb 2011 23:43:45 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: rdunlap@xenotime.net, greg@kroah.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Subject: [PATCH]Add a condition for CodingStyle
Message-ID: <20110219154344.GA3474@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
     When i see Documentation/CodingStyle, i find a missing case for "Chapter 3: Placing Braces and Spaces". We often know we should not use braces where a single statement. The first case is:
	if (condition)
		action();
Another case is:
	if (condition)
		do_this();
	else
		do_that();

     However, i can not find the second case. So i patch like following.

     Thanks.
     Best Regards.
     Harry Wei.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 Documentation/CodingStyle |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 8bb3723..37eac37 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -168,6 +168,13 @@ Do not unnecessarily use braces where a single statement will do.
 if (condition)
 	action();
 
+and
+
+if (condition)
+	do_this();
+else
+	do_that();
+
 This does not apply if one branch of a conditional statement is a single
 statement. Use braces in both branches.
 
-- 
1.7.0.4

