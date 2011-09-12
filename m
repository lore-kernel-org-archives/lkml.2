Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab1ILQZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:25:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41449 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1ILQY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:24:59 -0400
Date: Mon, 12 Sep 2011 09:24:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lin Ming <mlin@ss.pku.edu.cn>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/55] Preview of RCU changes for 3.2
Message-ID: <20110912162440.GA3045@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <CAF1ivSZ_THTHMPhXcPSJovxoi1WBvpr07ktMuYL39oode8kz0w@mail.gmail.com>
 <20110908174139.GL2671@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1109082122230.2723@ionos>
 <20110908204848.GA2701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908204848.GA2701@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 01:48:48PM -0700, Paul E. McKenney wrote:
> On Thu, Sep 08, 2011 at 09:23:05PM +0200, Thomas Gleixner wrote:
> > On Thu, 8 Sep 2011, Paul E. McKenney wrote:

[ . . . ]

> > > Hello, Lin,
> > > 
> > > I am unlikely to figure out why github doesn't like me by the end of
> > > the week, so please feel free to post the patches somewhere.  If you
> > > have a -tip tree handy, you could apply them on top of tip/master.
> > > If you don't have a -tip tree handy, they should also apply cleanly
> > > onto v3.0.
> > 
> >   git://tesla.tglx.de/git/linux-2.6-tip
> > 
> > Just in case.
> 
> Thank you very much, Thomas!!!

And now that I have finished herding the cats at Linux Plumbers Conference,
I did figure out how to make github accept my push requests.  Please see
https://github.com/paulmckrcu/linux.

							Thanx, Paul
