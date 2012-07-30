Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2G3Qbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:31:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:36491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2G3Qbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:31:46 -0400
Message-ID: <1343665886.20897.6.camel@twins>
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
Date: Mon, 30 Jul 2012 18:31:26 +0200
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
> Would 'is_hooked' be better? 'is_hooking' sounds more like what women in
> high heels, really short skirts and lots of makeup are doing late night
> on a corner of a Paris street ;-)

This is exactly the first thing I though of when I read the name ;-)

> A comment to explain the purpose should be added regardless. 

Ack.
