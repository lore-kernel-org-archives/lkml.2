Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0IAUhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:37:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57789 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0IAUhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:37:32 -0400
Date: Wed, 1 Sep 2010 13:37:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/urgent] make setpgid() system call use RCU read-side
 critical section
Message-ID: <20100901203730.GA23152@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request fixes an RCU lockdep splat noticed by Andrew Morton.

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

							Thanx, Paul

------------------>
Paul E. McKenney (1):
      pid: make setpgid() system call use RCU read-side critical section

 kernel/sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
