Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506Ab2EQWdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:33:06 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3527 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030224Ab2EQWdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:33:03 -0400
Message-ID: <1337293951.29587.5.camel@x61.thuisdomein>
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Date: Fri, 18 May 2012 00:32:31 +0200
In-Reply-To: <1337293209.4281.111.camel@twins>
References: <20120517221217.GA12196@linux.vnet.ibm.com>
	 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1337293209.4281.111.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 17 May 2012 22:32:41.0718 (UTC) FILETIME=[F8BA9960:01CD347C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 00:20 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-17 at 15:12 -0700, Paul E. McKenney wrote:
> > Although the C language allows you to break strings across lines, doing
> > this makes it hard for people to find the Linux kernel code corresponding
> > to a given console message.  This commit therefore fixes broken strings
> > throughout RCU's source code. 
> 
> While I'm not a strict 80 chars zealot, I do find exceedingly long lines
> utterly annoying, editors either wrap them in the most hideous way or
> you don't see them.
> 
> I'm not going make a big fuss, but I don't think such patches are an
> improvement.

Would it be feasible to teach "git grep" to treat strings broken across
lines as one string?

Related wishes: teach "git grep" to only show hits in strings, or to
only show hits in comments, or to only show hits in code (ie, not
strings or comments).


Paul Bolle

