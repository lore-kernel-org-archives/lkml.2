Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967256Ab2EQPdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:33:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54688 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967178Ab2EQPdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:33:09 -0400
Message-ID: <1337268779.4281.38.camel@twins>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Thu, 17 May 2012 17:32:59 +0200
In-Reply-To: <20120517151838.GA8692@linux.vnet.ibm.com>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
	 <20120517151838.GA8692@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 08:18 -0700, Paul E. McKenney wrote:
> Some researchers at MIT RCU-ified this lock:
> 
> http://people.csail.mit.edu/nickolai/papers/clements-bonsai.pdf 

Ah, as have I [1].. and they seem to have gotten about as far as I have,
which means almost there but not quite [2] :-)

The most interesting case is file maps and they simply ignored those.
While I appreciate that from an academic pov, -- they can still write a
paper on the other interesting bits -- I don't really like it from a
practical point.

[1] https://lkml.org/lkml/2010/1/4/257
[2] https://lkml.org/lkml/2010/1/4/532


