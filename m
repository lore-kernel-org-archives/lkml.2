Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0JTOmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:42:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49560 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752296Ab0JTOmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:42:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+pCGRqywepDHFC6COtxlSxtQ89NUJQc/QG5dfOzm
	NE9BD4GY+aAu7K
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <i9msce$97o$1@dough.gmane.org>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <i9msce$97o$1@dough.gmane.org>
Content-Type: text/plain
Date: Wed, 20 Oct 2010 16:41:53 +0200
Message-Id: <1287585713.18165.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 15:55 +0200, Markus Trippelsdorf wrote:
> Mike Galbraith wrote:
> 
> > Comments, suggestions etc highly welcome.
> 
> I've tested your patch and it runs smoothly on my machine.
> However I had several NULL pointer dereference BUGs that happened when I 
> left X or rebooted my system. I think this is caused by your patch. 
> There is nothing in the logs unfortunately, but I scribbled down the 
> following by hand (not the whole trace, I'm too lazy):
> 
> BUG: unable to handle NULL pointer dereference at 0..038
> IP:   pick_next_task_fair 0xa7/0x1a0
> ...
> Call Trace: schedule 
> ...

Hm.  Not much I can do without the trace, but thanks for testing and
reporting anyway, guess I need to do some heavy stress testing.  I'm
re-writing it as I write this anyway.

        thanks,

        -Mike

