Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1HISrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:47:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:37661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1HISrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:47:47 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt8
From: Peter Zijlstra <peterz@infradead.org>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 09 Aug 2011 20:47:26 +0200
In-Reply-To: <4E417D12.70608@localhost>
References: <1312580681.28695.44.camel@twins> <4E417D12.70608@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312915646.1083.79.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 11:31 -0700, Fernando Lopez-Lezcano wrote:
> Hmmm, what are reasonable values for CONFIG_RCU_BOOST_PRIO and 
> CONFIG_RCU_BOOST_DELAY? (or at least what are you using?).

I'm using the defaults, since I haven't actually got a workload besides
compiling kernels ;-)

Changing these values is very much workload dependent, the PRIO should
be high enough not to cause memory starvation, but low enough not to
disrupt anything important, and thus completely dependent on you
favourite RT workload.

The same goes for the DELAY, too long and you run out of memory, too
short and you get more overhead, depends on your workload, your machine
memory size etc..

Paul should of course be put on trial for giving us these knobs, but
seeing where they come from I totally understand they exist ;-)
