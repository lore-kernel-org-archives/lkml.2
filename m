Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967821Ab2EQWUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:20:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:46684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967208Ab2EQWUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:20:36 -0400
Message-ID: <1337293209.4281.111.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Date: Fri, 18 May 2012 00:20:09 +0200
In-Reply-To: <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120517221217.GA12196@linux.vnet.ibm.com>
	 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 15:12 -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Although the C language allows you to break strings across lines, doing
> this makes it hard for people to find the Linux kernel code corresponding
> to a given console message.  This commit therefore fixes broken strings
> throughout RCU's source code. 

While I'm not a strict 80 chars zealot, I do find exceedingly long lines
utterly annoying, editors either wrap them in the most hideous way or
you don't see them.

I'm not going make a big fuss, but I don't think such patches are an
improvement.
