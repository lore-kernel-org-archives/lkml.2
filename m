Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab2EIOXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:23:43 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:24132 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755874Ab2EIOXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:23:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rmgcbSgVM1m8kIlNtgaVZtMZXwl.aDtGr.oTHxK2mIQoFrU
 1EpUhbnXZD5aqIsawyPKE5R2jpQXSrBSEKOyp3R01TIuYNC8hvVDg_EAfxq.
 9pCHa2JROHb.5XiduBn4nwEgO2J8MTw4Z.LinR8C5Cbc8bJw8FLYElaAWhIR
 sB8OcYo2jS31KotBIPaTph954Lt9zsffsGg7W.1BRnZ.eSfO69OUZPU9bVPV
 PKKKUjRcWdUoErFf06z4_Ft4.IswZgK3Axds_vG6_nYVKqh9uLWkNhLghMG4
 3U7y_OTlwnkO4aP.3rpRFfidiApafKXp6HM1dF_MtZJ2QiXBkTT5D.KO7jhn
 6EvExi92ZqFmZDOXnafkbIDEdlMQzDls3NpoUeNU3dVGY2PBW2XABErDPwUU
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 09:23:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
In-Reply-To: <CAFTL4hx_b-XvqQDswtPnaDZLj6hBjoescBS3A8oFpCGPPUByrg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205090922510.8171@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins> <alpine.DEB.2.00.1205081016370.27713@router.home> <1336490832.8226.5.camel@twins> <alpine.DEB.2.00.1205081035550.27713@router.home> <1336492081.8226.13.camel@twins> <alpine.DEB.2.00.1205081054310.27713@router.home>
 <1336493768.8226.29.camel@twins> <1336506601.7400.21.camel@marge.simpson.net> <alpine.DEB.2.00.1205081541010.1391@router.home> <1336537289.7365.62.camel@marge.simpson.net> <CAFTL4hx_b-XvqQDswtPnaDZLj6hBjoescBS3A8oFpCGPPUByrg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Frederic Weisbecker wrote:

> May be I should indeed rather use sysfs, it's actually true that cpusets
> is confusing for this kind of thing.

Yes lets manage the cpu characteristics from the directory with the cpu
properties.
