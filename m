Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2C0QYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:24:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2C0QYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:24:33 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=3MQ0ZmHyo4IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=dOFtwhc8ZEl-KJzZ4hMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332865469.23924.129.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Date: Tue, 27 Mar 2012 12:24:29 -0400
In-Reply-To: <alpine.DEB.2.00.1203271111110.1170@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <1332338318-5958-13-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1203210953220.20482@router.home>
	 <20120327121341.GE13196@somewhere>
	 <alpine.DEB.2.00.1203271111110.1170@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 11:13 -0500, Christoph Lameter wrote:

> Please do not use "realtime" since I am not sure what you mean by that.
> Its for a low latency applications that cannot use "realtime" because that
> implies high latencies.

This statement totally confuses me, as the whole point of the -rt
(realtime) patch, is for lower latencies. Where do you get "realtime"
implies high latencies from?

-- Steve


