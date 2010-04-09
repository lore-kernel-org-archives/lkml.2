Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0DIFrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:47:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55027 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab0DIFrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:47:06 -0400
Date: Thu, 8 Apr 2010 22:47:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent] rcu: updates for RCU lockdep
Message-ID: <20100409054701.GA8833@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

These four patches provides a pair of new APIs and documentation to handle
a couple of cases that David Howells came across when running an NFS
workload under CONFIG_PROVE_RCU, along with some comment improvements
suggested by David and also some by Yong Zhang.

							Thanx, Paul

 b/Documentation/RCU/NMI-RCU.txt   |   39 +++++++++++++++++++++-----------------
 b/Documentation/RCU/checklist.txt |    7 +++---
 b/Documentation/RCU/lockdep.txt   |   28 +++++++++++++++++++++++++--
 b/Documentation/RCU/whatisRCU.txt |    6 +++++
 b/include/linux/rcupdate.h        |   33 ++++++++++++++++++++++++++++++++
 include/linux/rcupdate.h          |   30 +++++++++++++++++++++++------
 6 files changed, 115 insertions(+), 28 deletions(-)
