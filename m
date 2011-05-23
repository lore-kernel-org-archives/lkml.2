Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1EWTCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:02:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38760 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab1EWTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:02:16 -0400
Date: Mon, 23 May 2011 11:57:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 2/5] Documentation: update epoll sysctl text
Message-Id: <20110523115733.45c780fd.randy.dunlap@oracle.com>
In-Reply-To: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
References: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DDAAF17.00E0:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

max_user_instances was removed in this commit:

   commit 9df04e1f25effde823a600e755b51475d438f56b
   Author: Davide Libenzi <davidel@xmailserver.org>
   Date:   Thu Jan 29 14:25:26 2009 -0800

    epoll: drop max_user_instances and rely only on max_user_watches

but the documentation entry was not removed.

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/sysctl/fs.txt |    7 -------
 1 file changed, 7 deletions(-)

--- linux-2.6.39-git6.orig/Documentation/sysctl/fs.txt
+++ linux-2.6.39-git6/Documentation/sysctl/fs.txt
@@ -231,13 +231,6 @@ its creation).
 
 This directory contains configuration options for the epoll(7) interface.
 
-max_user_instances
-------------------
-
-This is the maximum number of epoll file descriptors that a single user can
-have open at a given time. The default value is 128, and should be enough
-for normal users.
-
 max_user_watches
 ----------------
 
