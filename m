Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab2F0Om2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:42:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48204 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab2F0Om0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:42:26 -0400
Date: Wed, 27 Jun 2012 07:14:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch V2 0/7] Per cpu thread hotplug infrastructure
Message-ID: <20120627141434.GA2418@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615140217.933711648@linutronix.de>
 <20120626232620.GA24468@linux.vnet.ibm.com>
 <1340790739.10063.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340790739.10063.5.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062714-7606-0000-0000-00000184D68D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 11:52:19AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-26 at 16:26 -0700, Paul E. McKenney wrote:
> > there might be other reasons to park besides
> > CPU hotplug.  Thoughts? 
> 
> s2r, freezers and similar stuff?

OK, so it sounds like the full functionality should be available in
!SMP kernels, then...

							Thanx, Paul

