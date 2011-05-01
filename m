Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab1EAP30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:29:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52535 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1EAP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:29:25 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 1 May 2011 08:29:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 16/86] rcu: make rcutorture version numbers
 available through debugfs
Message-ID: <20110501152903.GC14829@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-16-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304256126-26015-16-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:20:56AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> It is not possible to accurately correlate rcutorture output with that
> of debugfs.  This patch therefore adds a debugfs file that prints out
> the rcutorture version number, permitting easy correlation.

You can't accurately correlate debugfs values with each
other, either, right?  The rcutorture version number can change between
accesses to different debugfs files.

- Josh Triplett
