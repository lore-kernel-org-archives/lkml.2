Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1HRNa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:30:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1HRNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:30:28 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=XpnbWBGJ_lgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yMhMjlubAAAA:8 a=roPpAjhHodnVthOtiEgA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 0/7] priority-boost urcu
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
        Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110818122828.GB31100@Krystal>
References: <cover.1313478311.git.laijs@cn.fujitsu.com>
	 <4E4B7FEB.6050200@redhat.com> <4E4C971D.9020902@cn.fujitsu.com>
	 <20110818122828.GB31100@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 09:30:25 -0400
Message-ID: <1313674225.15704.68.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ not sure who wrote this but...]

> > > What we should introduce is abstractions over futexes.  This is what
> > > I did to experimentally port URCU to QEMU---my secret goal since
> > > commit 806f811 (use kernel style makefile output, 2010-03-01). :)
> > > Our use of futexes is exceptionally similar to a Windows
> > > manual-reset event (yes, Windows:
> > > http://msdn.microsoft.com/en-us/library/system.threading.manualresetevent%28v=vs.80%29.aspx).
> > > In QEMU I added the manual-reset event and use it in the
> > > implementation of RCU.

Be careful with this. You better make sure that Microsoft does not hold
any patents to this method, otherwise all your work will be in vain.

-- Steve


