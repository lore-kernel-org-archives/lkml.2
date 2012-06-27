Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2F0Jwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:52:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60724 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2F0Jwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:52:31 -0400
Message-ID: <1340790739.10063.5.camel@twins>
Subject: Re: [RFC patch V2 0/7] Per cpu thread hotplug infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Date: Wed, 27 Jun 2012 11:52:19 +0200
In-Reply-To: <20120626232620.GA24468@linux.vnet.ibm.com>
References: <20120615140217.933711648@linutronix.de>
	 <20120626232620.GA24468@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 16:26 -0700, Paul E. McKenney wrote:
> there might be other reasons to park besides
> CPU hotplug.  Thoughts? 


s2r, freezers and similar stuff?
