Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2KNBOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:14:11 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60074 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab2KNBOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:14:09 -0500
Date: Tue, 13 Nov 2012 17:07:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121114010703.GR2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121113004906.GA10557@linux.vnet.ibm.com>
 <201211132122.30259.tim01@vlsi.informatik.tu-darmstadt.de>
 <20121113212034.GD2489@linux.vnet.ibm.com>
 <201211140032.37320.tim01@vlsi.informatik.tu-darmstadt.de>
 <20121114000648.GN2489@linux.vnet.ibm.com>
 <20121114003641.GB7858@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114003641.GB7858@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111401-7182-0000-0000-0000032FB57D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 04:36:42PM -0800, Josh Triplett wrote:
> On Tue, Nov 13, 2012 at 04:06:48PM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 14, 2012 at 12:32:36AM +0100, Tim Sander wrote:
> > > Hi Paul
> > > 
> > > Sorry english somehow i tried to shoehorn more than one sentence into one 
> > > sentence in the last mail.
> > > > OK, how much memory does your device have?
> > > It's 128Mb of memory.
> > 
> > That is a bit on the smaller side.  But still quite large compared
> > to the 15K difference between CONFIG_TREE_PREEMPT_RCU and
> > CONFIG_TINY_PREEMPT_RCU.
> 
> I'd also expect CONFIG_TINY_PREEMPT_RCU to have marginally more
> performance on a UP system, but probably not enough to matter.

Agreed, I would expect this to be down in the noise.

							Thanx, Paul

