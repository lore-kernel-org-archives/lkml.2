Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1EWTCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:02:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39090 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab1EWTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:02:32 -0400
Date: Mon, 23 May 2011 11:58:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Harry Wei <harryxiyou@gmail.com>
Subject: [PATCH 3/5] Documentation: update LXR web link
Message-Id: <20110523115839.6bd8ce2b.randy.dunlap@oracle.com>
In-Reply-To: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
References: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4DDAAF27.00D8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

Update LXR (Linux cross reference) web link.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/HOWTO |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.39-git6.orig/Documentation/HOWTO
+++ linux-2.6.39-git6/Documentation/HOWTO
@@ -209,7 +209,7 @@ tools.  One such tool that is particular
 Cross-Reference project, which is able to present source code in a
 self-referential, indexed webpage format. An excellent up-to-date
 repository of the kernel code may be found at:
-	http://users.sosdg.org/~qiyong/lxr/
+	http://lxr.linux.no/+trees
 
 
 The development process
