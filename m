Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1EBRo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:44:58 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48738 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1EBRo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:44:58 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Mon, 2 May 2011 10:44:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 17/86] rcu: fix boost-tracing bug and update
 tracing documentation
Message-ID: <20110502174442.GB24574@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501154310.GD14829@feather>
 <20110502083301.GY2297@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502083301.GY2297@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 01:33:01AM -0700, Paul E. McKenney wrote:
> On Sun, May 01, 2011 at 08:43:10AM -0700, Josh Triplett wrote:
> > Also, does rcu/rcutorture appear with rcutorture not loaded?  Hopefully
> > not, since rcutorture shouldn't take up any additional resources when
> > not loaded.
> 
> Not much choice, unfortunately.  If I put the info into rcutorture, then
> I lose it when rcutorture is unloaded.  This is problematic in automated
> tests that repeatedly load and unload rcutorture.
> 
> But the amount of data is small, and I set things up so that TINY_RCU
> can omit this.  TREE_RCU is big enough that it doesn't really matter.

You could omit it entirely if CONFIG_RCU_TORTURE_TEST=n (rather than
=m).

- Josh Triplett
