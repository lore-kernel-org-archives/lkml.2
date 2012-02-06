Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab2BFHFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:05:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46245 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2BFHFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:05:09 -0500
Date: Sun, 5 Feb 2012 23:04:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC 0/41] RCU commits for 3.4
Message-ID: <20120206070442.GD5941@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <871uqcc0p9.fsf@ti.com>
 <20120202235852.GO2518@linux.vnet.ibm.com>
 <87obtf66bj.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obtf66bj.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020607-7282-0000-0000-0000063D72AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 11:54:40AM -0800, Kevin Hilman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Thu, Feb 02, 2012 at 02:47:14PM -0800, Kevin Hilman wrote:
> >> Hi Paul,
> >> 
> >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> >> 
> >> > This patchset makes RCU more aggressive about entering dyntick-idle mode
> >> > in order to improve energy efficiency, 
> >> 
> >> I gave this series a spin on an ARM/SMP platform (OMAP4) and the boot
> >> hung (tail end of boot log below.)  I then realized that had isolcpus=1
> >> on the cmdline from a previous experiment.  Removing isolcpus from the
> >> cmdline got me back to a working boot.
> >> 
> >> IIRC, some want to remove isolcpus, so I'm not sure if it's expected to
> >> work with your series, but thought you'd want to know.
> >
> > Not expected behavior, thank you for testing!
> >
> > Could you please share your .config?
> 
> Sure, attached.

Interesting...

Could you please try to reproduce with CONFIG_RCU_CPU_STALL_INFO=y?

That will give me some additional diagnostic information.

							Thanx, Paul

