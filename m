Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0LTQZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:25:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47342 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0LTQZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:25:22 -0500
Subject: Re: [RFC PATCH 03/15] nohz_task: Make tick stop and restart
 callable outside idle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292861950.22905.26.camel@gandalf.stny.rr.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-4-git-send-email-fweisbec@gmail.com>
	 <1292860133.5021.7.camel@laptop>
	 <1292861950.22905.26.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 17:25:11 +0100
Message-ID: <1292862311.5021.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 11:19 -0500, Steven Rostedt wrote:
> On Mon, 2010-12-20 at 16:48 +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > +                       if (!current->pid)
> > 
> > I'm not exactly sure that's the sanest way to test if you're the idle
> > thread...
> 
> Would
> 
>  if (idle_cpu(cpu))
> 
> be better?

Lots ;-)
