Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2AXWnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:43:53 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51495 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2AXWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:43:51 -0500
Date: Tue, 24 Jan 2012 14:43:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120124224345.GG2381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <1327435069.2767.1.camel@edumazet-laptop>
 <20120124211137.GD2381@linux.vnet.ibm.com>
 <20120124220700.GA11725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124220700.GA11725@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012422-3270-0000-0000-00000376CE71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 10:07:00PM +0000, Mark Brown wrote:
> On Tue, Jan 24, 2012 at 01:11:37PM -0800, Paul E. McKenney wrote:
> 
> > Hmmm...  Residual power dissipation is given in milliwatts.  I could
> > imagine some heartburn from many of the more aggressive embedded folks,
> > given that they might prefer microwatts -- or maybe even nanowatts,
> > for all I know.
> 
> FWIW idle battery referenced draw from a modern smartphone will be in
> the low single digit miliwatts or so.

Ah, OK, so only the non-smart cellphones would care, but they generally
don't run Linux, from what I understand.  Thanks for the info!

							Thanx, Paul

