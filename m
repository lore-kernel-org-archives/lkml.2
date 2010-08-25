Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0HYST0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:19:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:36585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0HYSTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:19:24 -0400
Date: Wed, 25 Aug 2010 18:18:54 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100825155850.GA6601@linux.vnet.ibm.com>
References: <20100825155850.GA6601@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] MAINTAINERS: Add RCU's public git tree
Message-ID: <tip-6cb6cbeaa9d6573c674842b9471c0467967aae99@git.kernel.org>
Git-Commit-ID: 6cb6cbeaa9d6573c674842b9471c0467967aae99
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 18:18:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6cb6cbeaa9d6573c674842b9471c0467967aae99
Gitweb:     http://git.kernel.org/tip/6cb6cbeaa9d6573c674842b9471c0467967aae99
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 25 Aug 2010 08:58:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Aug 2010 20:14:58 +0200

MAINTAINERS: Add RCU's public git tree

RCU now has a public git tree, so add it via the T: line in the
MAINTAINERS file.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: joe@perches.com
LKML-Reference: <20100825155850.GA6601@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5fa8451..614861a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4799,6 +4799,7 @@ RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4823,6 +4824,7 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/
 F:	include/linux/rcu*
 F:	include/linux/srcu*
