Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2FNLVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:21:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:55837 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2FNLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:21:32 -0400
Date: Thu, 14 Jun 2012 13:21:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive
 tickless
In-Reply-To: <20120614111638.GA16676@gmail.com>
Message-ID: <alpine.LFD.2.02.1206141321010.3086@ionos>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com> <1339664829.2559.14.camel@twins> <20120614111241.GA16848@somewhere> <20120614111638.GA16676@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > You're right, I should have looked into CONFIG_VIRT_CPU_ACCOUNTING sooner
> > and see if I can reuse it.
> > 
> > I'll try something with that.
> 
> Maybe sanitize all the variants under a single set of 
> wrappers/callbacks?

Yes, please!
