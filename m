Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0HYQCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 12:02:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35904 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab0HYP7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:59:16 -0400
Date: Wed, 25 Aug 2010 08:58:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu
Subject: [PATCH] MAINTAINERS: add RCU's public git tree
Message-ID: <20100825155850.GA6601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RCU now has a public git tree, so add it via the T: line in the
MAINTAINERS file.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a1df54b..3f21c27 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4800,6 +4800,7 @@ RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4824,6 +4825,7 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/
 F:	include/linux/rcu*
 F:	include/linux/srcu*
