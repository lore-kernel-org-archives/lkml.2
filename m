Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1H2PoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:44:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1H2PoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:44:10 -0400
Subject: Re: [PATCH 15/32] nohz/cpuset: Restart tick when switching to idle
 task
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 17:43:40 +0200
In-Reply-To: <1313423549-27093-16-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-16-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314632620.2816.100.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> Ideally if we are in adaptive nohz mode and we switch to the
> the idle task, we shouldn't restart the tick since it's going
> to stop the tick soon anyway.
> 
> That optimization requires some minor tweaks here and there
> though, lets handle that later. 

You have a knack for confusing changelogs.. so basically you say:

  Restart the tick when we switch to idle.

Now all that needs is an explanation of why..

Also, please drop the whole cpuset_nohz_ stuff, this really isn't about
cpusets, cpusets simly provide the interface, the functionality lives in
the tick_nohz_ namespace.
