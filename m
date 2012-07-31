Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2GaRe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:34:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2GaRe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:34:57 -0400
Message-ID: <1343751262.20897.29.camel@twins>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 31 Jul 2012 18:14:22 +0200
In-Reply-To: <20120731145742.GA6934@gmail.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
	 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
	 <1343660892.20897.3.camel@twins>
	 <20120730155059.GB17078@somewhere.redhat.com>
	 <20120731070640.GA2950@gmail.com>
	 <20120731104845.GC17078@somewhere.redhat.com>
	 <20120731145742.GA6934@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 16:57 +0200, Ingo Molnar wrote:
> 
> 'callback', while a longer word, is almost always used as a noun 
> within the kernel - and it also has a pretty narrow meaning. 

An altogether different naming would be something like:

struct user_kernel_tracking {
	int want_uk_tracking;
	enum {
		in_kernel = 0,
		in_user,
	} uk_state;
};


