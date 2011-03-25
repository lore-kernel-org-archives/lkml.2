Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab1CYK01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:26:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933837Ab1CYK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:26:26 -0400
Subject: Re: [PATCH] sched: leave sched_setscheduler earlier if possible.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <1300976519.14261.141.camel@gandalf.stny.rr.com>
References: <1300971618.3960.82.camel@Palantir>
	 <1300976519.14261.141.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 11:28:30 +0100
Message-ID: <1301048910.2250.184.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 10:21 -0400, Steven Rostedt wrote:
> > @@ -4998,6 +4998,16 @@ recheck:
> 
> Peter, this is why I prefer:
> 
>  recheck:
> over
> recheck:
> 
And you know I prefer to fix the tools ;-)

