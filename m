Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0LUOeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 09:34:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0LUOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 09:34:43 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=xXPKnBZExRIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zhHnsjOIQjZ42ZYalIIA:9 a=In9p0CLLplHdNTE-ps-hZX_EvCgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 04/15] nohz_task: Stop the tick when the nohz task
 runs alone
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101221132226.GB1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-5-git-send-email-fweisbec@gmail.com>
	 <1292860299.5021.8.camel@laptop> <20101220233659.GB1715@nowhere>
	 <1292916958.5021.171.camel@laptop>  <20101221132226.GB1750@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Dec 2010 09:34:39 -0500
Message-ID: <1292942079.22905.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 14:22 +0100, Frederic Weisbecker wrote:
> On Tue, Dec 21, 2010 at 08:35:58AM +0100, Peter Zijlstra wrote:

> > No, and that worries me, you don't even seem to know what the tick does
> > and yet you're working on stopping it.
> 
> Yeah, I've been focusing a lot on preemption and rcu because they seemed
> to be the trickiest part of the thing, and I in the meantime I just forgot
> the rest or tagged it too quickly as details to deal with later. And I
> finally forgot them :)
> 
> Bah it's a first take, it can only improve ;)

Exactly!

This is an RFC, a "release early, release often" approach. And you Cc'd
all the right people. This is not something I expect to make into 2.6.38
though ;-)

-- Steve


