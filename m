Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab1DYApN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:45:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45446 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab1DYApJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:45:09 -0400
Date: Sun, 24 Apr 2011 17:45:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rp@svcs.cs.pdx.edu,
        linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        ltt-dev@lists.casi.polymtl.ca
Subject: LPC2011 Scaling Micro Conf
Message-ID: <20110425004504.GA14037@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Given the increasing numbers of CPUs on low-cost servers as well as
the appearance of SMP hand-held battery-powered devices, Linux Plumbers
2011 will feature a Scaling track, with topics including the following:

- What can the kernel do to help applications perform and scale better?
- What can applications do to help the kernel perform and scale better?
- Memory footprint:
  + 100MB here, 100MB there, pretty soon you are talking real memory!
  + Improving performance by decreasing icache and dcache footprint.
- Limits to scalability:
  + Technological limitations, especially hardware.
  + Complexity/maintainability limitations.
- Handling of non-CPU computational hardware (GPGPUs, crypto HW, etc.)
  + Can the kernel make good use of non-CPU computational hardware?
  + How best to enable user applications to use them?
- Dealing with the numerous remaining "little kernel locks"

The intended audience is developers interested in performance and
scalability throughout the Linux plumbing.

The deadline is April 30th.  Please submit your proposals, whether to
Scaling or to other microconferences, at:

	http://www.linuxplumbersconf.org/2011/ocw/events/LPC2011MC/proposals

The general track is also open for submissions until April 30th:

	http://www.linuxplumbersconf.org/2011/ocw/events/LPC2011/proposals

Either way, we look forward to seeing your submissions!

							Thanx, Paul
