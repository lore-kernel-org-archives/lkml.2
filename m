Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1JQCDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 22:03:30 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59534 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1JQCD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 22:03:29 -0400
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.15.19
Date: Sun, 16 Oct 2011 19:03:10 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 54/55] rcu: Make srcu_read_lock_held() call
 common lockdep-enabled function
Message-ID: <20111017020309.GI19421@leaf>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-54-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-54-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:48AM -0700, Paul E. McKenney wrote:
> A common debug_lockdep_rcu_enabled() function is used to check whether
> RCU lockdep splats should be reported, but srcu_read_lock() does not
> use it.  This commit therefore brings srcu_read_lock_held() up to date.

Should this patch go before 53, or merge into 53, to prevent the issues
you describe from occuring in a tree which has 53 applied but not 54?

- Josh Triplett
