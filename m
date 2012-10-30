Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab2J3QEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:04:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36090 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab2J3QEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:04:14 -0400
Date: Tue, 30 Oct 2012 09:03:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: nikunj@linux.vnet.ibm.com, dhaval.giani@gmail.com, a.p.zijlstra@chello.nl,
        keescook@chromium.org, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/4] Documentation updates for 3.8
Message-ID: <20121030160350.GA21837@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-7182-0000-0000-000002FD6AEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains documentation updates as follows:

1.	Fix a broken example in memory-barriers.txt.
2.	Fix a paper title in RTFP.txt. (Courtesy of Dhaval Giani.)
3.	Mention kfree_rcu() in the whatisRCU.txt section covering
	call_rcu(), and fix example code. (Courtesy of Kees Cook.)
4.	Add two more ways of combining RCU and reference counting
	in rcuref.txt.

							Thanx, Paul


 b/Documentation/RCU/RTFP.txt        |    2 -
 b/Documentation/RCU/listRCU.txt     |    2 -
 b/Documentation/RCU/rcuref.txt      |   61 ++++++++++++++++++++++++++++++++++--
 b/Documentation/RCU/whatisRCU.txt   |   13 ++++++-
 b/Documentation/memory-barriers.txt |    9 ++---
 5 files changed, 77 insertions(+), 10 deletions(-)

