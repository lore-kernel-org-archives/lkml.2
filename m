Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab0FWJLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:11:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0FWJLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:11:16 -0400
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Mason <chris.mason@oracle.com>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Oleg Nesterov <oleg@redhat.com>, tglx <tglx@linutronix.de>
In-Reply-To: <20100622211141.GC21149@elte.hu>
References: <20100520204810.GA19188@think>
	 <1277114522.1875.469.camel@laptop> <1277117647.1875.503.camel@laptop>
	 <1277125479.1875.510.camel@laptop> <1277213586.1875.704.camel@laptop>
	 <20100622211141.GC21149@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Jun 2010 11:10:57 +0200
Message-ID: <1277284257.1875.820.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 23:11 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > So this one boots and builds a kernel on a dual-socket nehalem.
> > 
> > there's still quite a number of XXXs to fix, but I don't think any of the 
> > races are crashing potential, mostly wrong accounting and scheduling iffies 
> > like.
> > 
> > But give it a go.. see what it does for you (x86 only for now).
> > 
> > Ingo, any comments other than, eew, scary? :-)
> 
> None, other than a question: which future kernel do you aim it for? I'd prefer 
> v2.6.50 or later ;-)

Well, assuming it all works out and actually reduces runqueue lock
contention we still need to sort out all those XXXs in there, I'd say at
the soonest somewhere near .38/.39 or so.

Its definitely not something we should rush in.
