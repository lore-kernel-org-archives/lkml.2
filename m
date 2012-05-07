Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2EGQGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:06:22 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:42840 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756818Ab2EGQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:06:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 10yDS1kVM1km2d3Z2fkuMnpMbfN5K7ZZTxCvz_sHIROFYn2
 hFQ4w7SBgBIs9XxssdD6J_tZKRuHGCJhWBxjVtYrOOZHHUgpWMeBjfEUHQBq
 3lxWE4kfzQZeitgiNirygzfOkWlKRnjXgLHm.0F6_L5CkeAND9eZo4Ogmg.T
 jjlcusNZ9EsyeLcTaIvwP3MfSoPOFnEq8StqrKWo9KKA9niG7pWMbfG9VocZ
 YbNLFQ1L2QcHJScN5hzqX5SRtei2WOmf.jXV55MEfhmeVddkjqqmFCeJJDti
 Hi.I1kqjJ9EZk1hJbB3ATP_SArBSXCblRRVPIkUkFGv.F4Ebtco1jewxmcxL
 .8x1izEameq0q8p_Pc6LyohJ00LMbEnVKVcdvwQcg8eGWQc3GdiQhiY.2TUq
 r
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 7 May 2012 10:51:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 04/41] nohz: Move nohz load balancer selection into idle
 logic
In-Reply-To: <1335830115-14335-5-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.1205071049040.1060@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-5-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Frederic Weisbecker wrote:

> [ ** BUGGY PATCH: I need to put more thinking into this ** ]
>
> We want the nohz load balancer to be an idle CPU, thus
> move that selection to strict dyntick idle logic.

An idle cpu? We may want to put it on a busy cpu that is running high
latency OS tasks. Would it be possible to have an option where we can pin
the load balancer to a specific cpu?
