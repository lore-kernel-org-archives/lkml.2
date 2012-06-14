Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2FNJHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:07:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35676 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2FNJHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:07:39 -0400
Message-ID: <1339664829.2559.14.camel@twins>
Subject: Re: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive
 tickless
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck,Tony" <tony.luck@intel.com>
Date: Thu, 14 Jun 2012 11:07:09 +0200
In-Reply-To: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 18:19 +0200, Frederic Weisbecker wrote:
> Ingo, Thomas,
> 
> This starts the basic code that allow accounting of cputime spent tickless
> outside idle, which is a first step to prepare for the adaptive nohz
> infrastructure.
> 
> I hope we can set a tree in -tip for that. If you're fine with it
> this is pullable from:

There's a number of architecture that already does fine grained
user/kernel time accounting on syscall boundaries etc.. s390, powerpc
and ia64.

You're now adding a 3rd way of accounting user/kernel time.. I'm not
much looking fwd to that..
