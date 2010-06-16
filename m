Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab0FPVRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:17:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:55177 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0FPVRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:17:31 -0400
Subject: Re: [PATCH 2/6: v4] lockdep: Make MAX_STACK_TRACE_ENTRIES
 configurable.
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       ghaskins@novell.com
In-Reply-To: <alpine.LFD.2.00.1006162213220.28756@localhost.localdomain>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
	 <1276554087-3632-3-git-send-email-jkacur@redhat.com>
	 <1276714154.1745.623.camel@laptop>
	 <alpine.LFD.2.00.1006162213220.28756@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 23:16:48 +0200
Message-ID: <1276723008.2077.9574.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 22:37 +0200, John Kacur wrote:
> 
> On Wed, 16 Jun 2010, Peter Zijlstra wrote:
> 
> > On Tue, 2010-06-15 at 00:21 +0200, John Kacur wrote:
> > > Certain debug configurations that have LOCKDEP turned on, run into the limit
> > > where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply turning
> > > off the locking correctness validator, let the user configure this value
> > > to something reasonable for their system.
> > > 
> > > This patch was generated against 2.6.33.5-rt23 but is also intended to be
> > > picked-up for mainline.
> > 
> > NACK
> > 
> > patches like 4726f2a617ebd868a4fdeb5679613b897e5f1676 are the way to go.
> 
> I've been testing 4726f2a617ebd868a4fdeb5679613b897e5f1676 in rt
> (Thomas has it in tip/rt/2.6.33 now) and so far it is doing the trick for 
> me, at least on my laptop. I still need to test it on larger machines.
> However, this problem seems to continuably come up, and I'm not the only 
> one who has expessed the wish / need to have this tunable.

And simply increasing the number without thought is the worst approach
ever and I'm simply not going to merge it.

Also, google doesn't seem to index msg-ids, so I've no idea what you're
referring to.
