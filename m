Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0HBA34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:29:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55424 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0HBA3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:29:55 -0400
Date: Sun, 1 Aug 2010 17:29:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, peterz@infradead.org,
        swetland@google.com, linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802002950.GQ2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.44L0.1008011810300.22928-100000@netrider.rowland.org>
 <866453.87809.qm@web180313.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <866453.87809.qm@web180313.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 03:38:34PM -0700, David Brownell wrote:
> > > > I should have made a stronger point:
> > "power-aware" is _not_ a good
> > > > term for these applications. 
> 
> Strongly disagree.  The whole point is that they
> ARE VERY MUCH AWARE and interact with a power
> policy to achieve goals.
> 
> Like refusing to power down active subsystems,
> or actively powering down inactive ones.
> Q.E.D. ... "aware".

My initial thoughts was along the same lines as yours, but after thinking
about it, the distinction between an application that controls its own
behavior ("power-aware application") and an application that controls the
system's behavior ("PM-driving application") seemed well worth its weight.

							Thanx, Paul
