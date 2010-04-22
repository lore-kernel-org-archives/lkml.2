Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0DVTyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:54:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39375 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581Ab0DVTyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:54:04 -0400
Date: Thu, 22 Apr 2010 12:53:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent] Fix RCU lockdep splats in keys and sched
Message-ID: <20100422195345.GA9639@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series fixes a pair of RCU lockdep splats in the keys subsystem
(courtesy of David Howells) and another in the scheduler.

							Thanx, Paul


 kernel/sched.c               |    6 +++++-
 security/keys/request_key.c  |   13 ++++++++-----
 security/keys/user_defined.c |    3 ++-
 3 files changed, 15 insertions(+), 7 deletions(-)
