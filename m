Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2INQft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:35:49 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47330 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2INQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:35:47 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] rcu: idle changes v2
Date: Fri, 14 Sep 2012 18:35:37 +0200
Message-Id: <1347640539-8470-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

This is the second version of my rcu/idle-for-v3.7 which rebases
your rcu/idle to address reviews.

It has the same modifications than rcu/idle-for-v3.7 plus
an update of:

- "rcu: Exit RCU extended QS on user preemption" : update changelog
and comments after a discussion with Peterz. And compile conditionally
schedule_user().

- "x86: Use the new schedule_user API on userspace preemption" : build
time choose between calling schedule and schedule_user.

I'm only reposting these two patches.

The new branch is:

git://github.com/fweisbec/linux-dynticks.git
	rcu/idle-v2-for-v3.7

Thanks.
