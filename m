Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2FDTGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:06:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55201 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2FDTGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:06:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120604181313.GL2490@linux.vnet.ibm.com>
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
	<20120604181313.GL2490@linux.vnet.ibm.com>
Date: Mon, 4 Jun 2012 21:06:22 +0200
Message-ID: <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
Subject: Re: [PATCH 0/2] rcu: Extended quiescent state for adaptive nohz
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/4 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Mon, Jun 04, 2012 at 02:08:26PM +0200, fweisbec@gmail.com wrote:
>> From: Frederic Weisbecker <fweisbec@gmail.com>
>>
>> Paul, Ingo,
>>
>> This is a rebase of the nohz cpusets RCU APIs on top of Paul's latest
>> -rcu (rcu/core) branch.
>>
>> I have only built tested it yet, I need to do a full rebase of my
>> tree to test it in practice. But I wanted to show you how it looks
>> like first.
>>
>> I also wonder if we can set that to a tree somewhere. Ingo suggested
>> to set up a tree on -tip to apply the uncontroversial part of nohz
>> cpusets patches and iterate from there. I think it would accelerate
>> everything if we start doing that.
>
> It would probably be best to put these two in the -rcu set in order to
> avoid conflicts with possible further RCU_FAST_NO_HZ work.  I could
> push this to -tip early, if that would help.

But then these APIs are going to be upstream on 3.6
Is that ok for you even if they don't have any upstream user?
We can ifdef it.
