Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab2GMUzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab2GMUy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:54:57 -0400
Date: Fri, 13 Jul 2012 16:54:36 -0400
From: Dave Jones <davej@redhat.com>
To: Darren Hart <darren@dvhart.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
Message-ID: <20120713205436.GF1707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <darren@dvhart.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120713180823.GA24972@redhat.com>
 <alpine.LFD.2.02.1207132032330.32033@ionos>
 <20120713185402.GA1707@redhat.com>
 <alpine.LFD.2.02.1207132108340.32033@ionos>
 <20120713195615.GC1707@redhat.com>
 <CAGChsmNnE_iEKWagULzewSPWsAbaA2A-mXg4CS+vyG3a8Pbj1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGChsmNnE_iEKWagULzewSPWsAbaA2A-mXg4CS+vyG3a8Pbj1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 01:27:41PM -0700, Darren Hart wrote:
 > I'm returning from a family vacation just now, I'll have a closer look on
 > Monday. It seems to me we recently had some futex lockdep annotations go
 > in, any chance those are somehow involved?
 > 
 > So we have a real user of the futex requeue pi code? Is this via pthread
 > condvars? Is this test available for me to run?

I wouldn't call it a "real user" per se.
details (including git checkout) at http://codemonkey.org.uk/projects/trinity/

	Dave
