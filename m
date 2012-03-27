Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2C0PKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:10:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:52065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2C0PKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:10:51 -0400
Message-ID: <1332861025.16159.236.camel@twins>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
From: Peter Zijlstra <peterz@infradead.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Date: Tue, 27 Mar 2012 17:10:25 +0200
In-Reply-To: <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 17:02 +0200, Gilad Ben-Yossef wrote:
> 
> In my case, I also had to disable the clocksource watchdog, but only
> because TSC is not stable on my VM.
> This is really not a nohz/cpuset problem. 

No but that thing is annoying, I ran afoul of it too the other day.

Thomas, would you object to a means of turning that thing off? And if
not, do you have a preference as to what particular means
(sysctl/sysfs/etc..) ?
