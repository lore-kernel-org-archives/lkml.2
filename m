Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2KNAW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:22:58 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45922 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2KNAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:22:56 -0500
Date: Tue, 13 Nov 2012 16:06:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121114000648.GN2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121113004906.GA10557@linux.vnet.ibm.com>
 <201211132122.30259.tim01@vlsi.informatik.tu-darmstadt.de>
 <20121113212034.GD2489@linux.vnet.ibm.com>
 <201211140032.37320.tim01@vlsi.informatik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211140032.37320.tim01@vlsi.informatik.tu-darmstadt.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111400-5406-0000-0000-00000205F68E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 12:32:36AM +0100, Tim Sander wrote:
> Hi Paul
> 
> Sorry english somehow i tried to shoehorn more than one sentence into one 
> sentence in the last mail.
> > OK, how much memory does your device have?
> It's 128Mb of memory.

That is a bit on the smaller side.  But still quite large compared
to the 15K difference between CONFIG_TREE_PREEMPT_RCU and
CONFIG_TINY_PREEMPT_RCU.

							Thanx, Paul

