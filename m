Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2AXWHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:07:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52245 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2AXWHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:07:07 -0500
Date: Tue, 24 Jan 2012 22:07:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120124220700.GA11725@sirena.org.uk>
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <1327435069.2767.1.camel@edumazet-laptop>
 <20120124211137.GD2381@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124211137.GD2381@linux.vnet.ibm.com>
X-Cookie: The second best policy is dishonesty.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:11:37PM -0800, Paul E. McKenney wrote:

> Hmmm...  Residual power dissipation is given in milliwatts.  I could
> imagine some heartburn from many of the more aggressive embedded folks,
> given that they might prefer microwatts -- or maybe even nanowatts,
> for all I know.

FWIW idle battery referenced draw from a modern smartphone will be in
the low single digit miliwatts or so.
