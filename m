Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2G3QeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:34:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2G3QeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:34:03 -0400
Message-ID: <1343665962.20897.8.camel@twins>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 30 Jul 2012 18:32:42 +0200
In-Reply-To: <1343664422.27983.12.camel@gandalf.stny.rr.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
	 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
	 <1343660892.20897.3.camel@twins>
	 <20120730155059.GB17078@somewhere.redhat.com>
	 <1343664422.27983.12.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 12:07 -0400, Steven Rostedt wrote:
> 
> Not only does bool describe it better, it should also allow gcc to
> optimize it better as well. Unless Peter has a legitimate rational why
> using bool in struct is bad, I would keep it as is. 

I don't mind too much, but like said, I hate using types without
specified storage, you never really know what the compiler will end up
doing.
