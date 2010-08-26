Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0HZPps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:45:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42173 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0HZPpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:45:44 -0400
Date: Thu, 26 Aug 2010 08:45:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, jkosina@suse.cz,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: [PATCH] MAINTAINERS: add U: for URL of todo list, add RCU todo list
Message-ID: <20100826154537.GA4874@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since T: and L: are already taken, add U: for URL of todo list.
Also add the RCU todo list to both the RCU and RCUTORTURE projects.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3f21c27..1c57186 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -103,6 +103,7 @@ Descriptions of section entries:
 	      matches patches or files that contain one or more of the words
 	      printk, pr_info or pr_err
 	   One regex pattern per line.  Multiple K: lines acceptable.
+	U: URL of todo list.
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
@@ -4801,6 +4802,7 @@ M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4826,6 +4828,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+U:	http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
 F:	Documentation/RCU/
 F:	include/linux/rcu*
 F:	include/linux/srcu*
