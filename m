Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1AMTbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:31:32 -0500
Received: from www.tglx.de ([62.245.132.106]:36828 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716Ab1AMTba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:31:30 -0500
Date: Thu, 13 Jan 2011 20:29:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: avoid pointless blocked-task
 warnings
In-Reply-To: <1294945477-10612-2-git-send-email-paulmck@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1101132029130.2678@localhost6.localdomain6>
References: <20110113190414.GA10457@linux.vnet.ibm.com> <1294945477-10612-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Paul E. McKenney wrote:
> Reported-by: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

So finally someone managed to clone you ?
