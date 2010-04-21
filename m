Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0DULhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 07:37:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:53113 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab0DULhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 07:37:09 -0400
Subject: Re: [PATCH v3] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1004211309560.6646@localhost>
References: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain>
	 <alpine.LFD.2.00.1004161727000.11320@localhost.localdomain>
	 <alpine.LFD.2.00.1004191841230.6259@localhost>
	 <20100420140941.d085007d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004211309560.6646@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 13:37:03 +0200
Message-ID: <1271849823.1776.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 13:12 +0200, John Kacur wrote:
> 
> Certain configurations that have LOCKDEP turned on, run into the limit
> where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply
> turning of the locking correctness validator let the user configure this
> value to something reasonable for their system.

I'm not sure its worth having a CONFIG_ value for this, that'll just be
yet another random value nobody knows what to do with.

Do you actually have a machine that reproduces this? Can you see how
many classes, avg stacktraces per class and the avg entries per
stacktrace there are?

Also, is there's lots of classes, are there many with a similar name?

That is, is it a valid depletion or is there something wonkey with those
setups?

