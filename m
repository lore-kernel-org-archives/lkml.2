Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2BBCaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:30:55 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43937 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab2BBCay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:30:54 -0500
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 18:30:33 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC tip/core/rcu 21/41] rcu: Inform RCU of irq_exit()
 activity
Message-ID: <20120202023033.GN29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-21-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-21-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:39AM -0800, Paul E. McKenney wrote:
> [ Alternatively, delaying the ->rcu_read_lock_nesting decrement
>   until after the special handling would make the thing more robust
>   in the face of interrupts as well.  And there is a separate patch
>   for that. ]

Where does that separate patch live, and should it replace this one?

- Josh Triplett
