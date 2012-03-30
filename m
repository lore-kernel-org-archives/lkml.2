Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab2C3CH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 22:07:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44782 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759464Ab2C3CHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 22:07:23 -0400
Message-ID: <1333073233.4912.44.camel@smoke>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
From: Geoff Levand <geoff@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Ingo Molnar <mingo@kernel.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Max Krasnyansky <maxk@qualcomm.com>, Zen Lin <zen@openhuawei.org>,
        Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 29 Mar 2012 19:07:13 -0700
In-Reply-To: <20120330004527.GB2571@somewhere.redhat.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <87r4wbhqqd.fsf@ti.com> <20120330004527.GB2571@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Fri, 2012-03-30 at 02:45 +0200, Frederic Weisbecker wrote:
> On Thu, Mar 29, 2012 at 05:33:46PM -0700, Kevin Hilman wrote:
> > For anyone interested in collaborating on ARM support, my
> > work-in-progress branch is below[1] based on Frederic's cpuset-v2
> > branch.  Patches and testing welcome.
> > 
> > [1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git wip/arm-nohz-cpusets
> 
> Nice! Thanks for working on this. You may want to work with Geoff Levand who's working
> on the ARM port too.

You can see my work here:

  http://git.kernel.org/?p=linux/kernel/git/geoff/nohz.git

I also put a simple test I got from Frederic here:

  http://git.kernel.org/?p=linux/kernel/git/geoff/nohz-tests.git

Feel free to expand on either!

Kevin, I'll take a look at your work, I guess it has the same things as
mine.  Will you be at the Collaboration Summit next week?

-Geoff





