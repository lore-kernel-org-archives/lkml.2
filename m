Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1GNTjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:39:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab1GNTjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:39:37 -0400
Date: Thu, 14 Jul 2011 15:38:28 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110714193827.GA11552@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
 <1310661699.2309.13.camel@laptop>
 <20110714191508.GA3060@swordfish>
 <20110714193412.GA2317@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714193412.GA2317@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 12:34:12PM -0700, Paul E. McKenney wrote:
 
 > Thank you -- you were indeed running with CONFIG_PREEMPT and
 > CONFIG_RCU_BOOST, which would be the case for the bug that Steven Rostedt
 > found.  On reproducing, yes, it could be a bit tough, as the race window
 > is rather narrow.  I could probably add delays to force the situation htat
 > Steven found, but it would be hard to prove that this is your situation.
 > 
 > Dave, was your lockdep splat also with CONFIG_PREEMPT and
 > CONFIG_RCU_BOOST?

yeah. which might explain why I haven't seen it since. (I usually have it
disabled, but turn it on occasionally for a 'lets see what breaks' test)

	Dave
 
