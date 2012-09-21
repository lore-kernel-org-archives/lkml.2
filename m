Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2IUWDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:03:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39773 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2IUWDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:03:22 -0400
Date: Fri, 21 Sep 2012 15:03:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120921220302.GF2454@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
 <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <20120920232114.GO2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
 <20120921185827.GC2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
 <20120921195717.GD2454@linux.vnet.ibm.com>
 <20120921203149.GI28835@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921203149.GI28835@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092122-5518-0000-0000-000007D74570
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:31:49PM -0700, Tony Lindgren wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [120921 12:58]:
> > 
> > Just to make sure I understand the combinations:
> > 
> > o	All stalls have happened when running a minimal userspace.
> > o	CONFIG_NO_HZ=n suppresses the stalls.
> > o	CONFIG_RCU_FAST_NO_HZ (which depends on CONFIG_NO_HZ=y) has
> > 	no observable effect on the stalls.
> 
> The reason why you may need minimal userspace is to cut down
> the number of timers waking up the system with NO_HZ.
> Booting with init=/bin/sh might also do the trick for that.

Good point!  This does make for a very quiet system, but does not
reproduce the problem under kvm, even after waiting for four minutes.
I will leave it for more time, but it looks like I really might need to
ask Linaro for remote access to a Panda.

							Thanx, Paul

