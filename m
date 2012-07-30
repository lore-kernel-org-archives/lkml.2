Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2G3Qao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:30:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:36467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2G3Qan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:30:43 -0400
Message-ID: <1343665809.20897.5.camel@twins>
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
Date: Mon, 30 Jul 2012 18:30:09 +0200
In-Reply-To: <1343662074.27983.4.camel@gandalf.stny.rr.com>
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
	 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
	 <1343660892.20897.3.camel@twins>
	 <1343662074.27983.4.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-30 at 11:27 -0400, Steven Rostedt wrote:
> I'm curious to what you have against bool in structures?

_Bool as per the C std doesn't have a specified storage. Now IIRC hpa
recently said that all GCC versions so far were consistent and used char
(a byte) for it, but I might mis-remember.


