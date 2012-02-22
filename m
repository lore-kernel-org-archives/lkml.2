Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2BVPLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:11:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60004 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2BVPLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:11:48 -0500
Message-ID: <1329923493.24994.19.camel@twins>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Baron <jbaron@redhat.com>, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 16:11:33 +0100
In-Reply-To: <20120222145614.GA2491@elte.hu>
References: <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com>
	 <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com>
	 <20120222074839.GA24890@elte.hu>
	 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
	 <20120222080659.GA25318@elte.hu>
	 <1329916920.25686.79.camel@gandalf.stny.rr.com>
	 <20120222133404.GA14085@elte.hu>
	 <1329918881.25686.92.camel@gandalf.stny.rr.com>
	 <20120222145614.GA2491@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 15:56 +0100, Ingo Molnar wrote:
> > Again, maybe we need a "very_unlikely()" for the tracing case,
> 
> ... and that's the usecase for the scheduler, for events and for 
> networking. I.e. all current usecases in the kernel 

The scheduler also really wants the very_likely() variant. We have less
use for the unbiased one though.
