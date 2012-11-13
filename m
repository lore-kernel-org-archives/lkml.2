Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2KMBeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:34:09 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57735 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2KMBeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:34:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121113011712.GA20884@jtriplet-mobl1>
References: <20121113004906.GA10557@linux.vnet.ibm.com>
	<CAFTL4hyUBAAu_COi_V3aFr5j0eXZxnw48Hv8pe1cRTLO1eKYdA@mail.gmail.com>
	<20121113011712.GA20884@jtriplet-mobl1>
Date: Tue, 13 Nov 2012 02:34:06 +0100
Message-ID: <CAFTL4hyHHRzgsAy6KbA39YgEjPRkMRdDK17DWy_rehiyoJjo6A@mail.gmail.com>
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/13 Josh Triplett <josh@joshtriplett.org>:
> On Tue, Nov 13, 2012 at 02:12:27AM +0100, Frederic Weisbecker wrote:
>> 2012/11/13 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
>> > Hello!
>> >
>> > I know of people using TINY_RCU, TREE_RCU, and TREE_PREEMPT_RCU, but I
>> > have not heard of anyone using TINY_PREEMPT_RCU for whom TREE_PREEMPT_RCU
>> > was not a viable option (in contrast, the people running Linux on
>> > tiny-memmory systems typically use TINY_RCU).  Of course, if no one
>> > really needs it, the proper thing to do is to remove it.
>> >
>> > So, if you need TINY_PREEMPT_RCU, please let me know.  Otherwise, I will
>> > remove it, probably in the 3.9 timeframe.
>>
>> I don't use it personally but if you remove it, does that mean that
>> RCU couldn't be preemptible on UP?
>
> No, it would mean that on UP you could choose between TINY_RCU and
> TREE_PREEMPT_RCU, depending on whether you want tiny or preemptible.

Ok. I thought the TREE version wasn't possible anymore on UP when I
saw some patches that removed optimizations for nr_online_cpus=1.
Hence the confusion.
