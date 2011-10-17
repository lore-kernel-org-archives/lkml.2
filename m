Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1JQBxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:53:46 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34200 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1JQBxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:53:45 -0400
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.15.19
Date: Sun, 16 Oct 2011 18:53:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 42/55] rcu: Make rcu_torture_fqs() exit
 loops at end of test
Message-ID: <20111017015329.GG19421@leaf>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-42-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-42-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:36AM -0700, Paul E. McKenney wrote:
> The rcu_torture_fqs() function can prevent the rcutorture tests from
> completing, resulting in a hang.  This commit therefore ensures that
> rcu_torture_fqs() will exit its inner loops at the end of the test,
> and also applies the newish ULONG_CMP_LT() macro to time comparisons.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This seems like two entirely separate changes, which should go in
separate commits.

- Josh Triplett
