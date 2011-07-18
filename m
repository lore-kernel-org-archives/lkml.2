Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1GRLsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 07:48:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab1GRLsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 07:48:51 -0400
Date: Mon, 18 Jul 2011 14:48:34 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: current_thread_info() vs task_thread_info(current)
Message-ID: <20110718114834.GJ2400@redhat.com>
References: <1310988183.13765.56.camel@twins>
 <20110718113600.GI2400@redhat.com>
 <1310989490.13765.57.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310989490.13765.57.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 01:44:50PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-07-18 at 14:36 +0300, Gleb Natapov wrote:
> 
> > Why not use per cpu kernel_stack variable on all arches as x86_64 does?
> > How big the advantage of using stack pointer to find current thread info is?
> 
> One less load I imagine.
Oh, yes of course. But what I mean is that if using kernel_stack is good
enough for most popular architecture (x86_64) may be it is good enough for
other architectures too?

--
			Gleb.
