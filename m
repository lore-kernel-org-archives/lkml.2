Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab2EUSKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:10:34 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41827 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab2EUSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:10:33 -0400
Date: Mon, 21 May 2012 11:05:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org, laijs@cn.fujitsu.com
Subject: [GIT PULL rcu/next] More RCU commits for 3.5
Message-ID: <20120521180550.GA22052@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052118-7408-0000-0000-00000534FABC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series has only two minor patches:

1.	Fix code-style issues involving "else", where if one branch of
	the "if" statement requires curly brackets, the other branch
	must also use them.
2.	Fix strings broken across lines, strings being the exception to
	the 80-column rule.

All of these have been exposed to -next testing.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

							Thanx, Paul

-------------------------->
Paul E. McKenney (2):
      rcu: Fix code-style issues involving "else"
      rcu: Fix broken strings in RCU's source code.

 include/linux/rcupdate.h |    3 +--
 kernel/rcutiny_plugin.h  |    3 ++-
 kernel/rcutorture.c      |   36 ++++++++++++++++--------------------
 kernel/rcutree.c         |    7 ++++---
 kernel/rcutree_plugin.h  |   18 ++++++++++--------
 kernel/rcutree_trace.c   |   25 ++++++++++++-------------
 lib/list_debug.c         |    6 ++----
 7 files changed, 47 insertions(+), 51 deletions(-)

