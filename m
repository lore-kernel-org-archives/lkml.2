Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab0LUIOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:14:47 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58417 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab0LUIOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:14:46 -0500
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101221012418.GI1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
	 <1292859744.5021.4.camel@laptop> <20101220155737.GA1742@nowhere>
	 <1292861799.5021.27.camel@laptop>  <20101221012418.GI1715@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 09:14:40 +0100
Message-ID: <1292919280.5021.203.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 02:24 +0100, Frederic Weisbecker wrote:
> 
> > Also, I'm not quite happy with the pure userspace restriction, but at
> > least I see why you did that event though you didn't mention that.
> 
> What do you mean? The fact that kernel threads can not be nohz task? 

No, that you key off kernel/user boundary transitions. Arguably one
could allow simply system calls and page-faults to happen without
restarting the tick, then again, RCU is very pervasive these days so I'm
not quite sure you can actually make that happen.


