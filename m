Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1K1VY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:24:56 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61433 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1K1VYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:24:55 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 0/4] rcu: Make new RCU dynticks API work with nohz cpusets
Date: Mon, 28 Nov 2011 22:24:43 +0100
Message-Id: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

This is an attempt to make the current RCU dynticks API
working with the nohz cpusets.

I believe the two first patches could be pushed in your trees.
Patches 3 and 4 are rather something I plan to apply in mine,
given they are not needed upstream yet.

Waiting for your comments.

Thanks.

Frederic Weisbecker (4):
  rcu: Don't check irq nesting from rcu idle entry/exit
  rcu: Irq nesting is always 0 on rcu_enter_idle_common
  rcu: New rcu_user_enter() and rcu_user_exit() APIs
  rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs

 kernel/rcutree.c |  117 ++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 88 insertions(+), 29 deletions(-)

-- 
1.7.5.4

