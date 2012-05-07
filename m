Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2EGWK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:10:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43066 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2EGWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:10:55 -0400
Message-ID: <1336428636.5773.6.camel@smoke>
Subject: Re: [RFC][PATCH 00/41] Nohz cpusets v3 (adaptive tickless kernel)
From: Geoff Levand <geoff@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>, Kevin Hilman <khilman@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 07 May 2012 15:10:36 -0700
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Tue, 2012-05-01 at 01:54 +0200, Frederic Weisbecker wrote:
> A summary of what this is about can be found here:
>  https://lkml.org/lkml/2011/8/15/245
> 
> Changes since v2:
> ...

I rebased my ARM patches to Frederick's v3:

  http://git.kernel.org/?p=linux/kernel/git/geoff/nohz.git

-Geoff

