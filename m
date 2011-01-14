Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1ANNqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:46:31 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38132 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1ANNqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:46:25 -0500
Date: Fri, 14 Jan 2011 05:46:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rmk+kernel@arm.linux.org.uk, weber@corscience.de
Subject: [GIT PULL rcu/next] 2.6.38 fixes for RCU regressions
Message-ID: <20110114134620.GA12672@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request fixes a pair of RCU regressions introduced into 2.6.38.

These changes are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

These are against the current tip/core/rcu branch.

							Thanx, Paul

------------------>
Paul E. McKenney (2):
      rcu: demote SRCU_SYNCHRONIZE_DELAY from kernel-parameter status
      rcu: avoid pointless blocked-task warnings

 init/Kconfig     |   15 ---------------
 kernel/rcutiny.c |    3 ++-
 kernel/srcu.c    |   15 +++++++++++++--
 3 files changed, 15 insertions(+), 18 deletions(-)
