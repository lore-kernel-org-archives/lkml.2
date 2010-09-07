Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab0IGE4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:56:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab0IGE4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:56:05 -0400
Date: Tue, 7 Sep 2010 06:55:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, hch@lst.de,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100907045553.GA20770@elte.hu>
References: <20100628121554.GA6605@lst.de>
 <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
 <20100903150041.GA30573@elte.hu>
 <1283799222.15941.1393621887@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283799222.15941.1393621887@webmail.messagingengine.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> On Fri, 03 Sep 2010 17:00 +0200, "Ingo Molnar" <mingo@elte.hu> wrote:
> > 
> > * tip-bot for Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > Commit-ID:  7974891db234467eaf1fec613ec0129cb4ac2332
> > > Gitweb:     http://git.kernel.org/tip/7974891db234467eaf1fec613ec0129cb4ac2332
> > > Author:     Christoph Hellwig <hch@lst.de>
> > > AuthorDate: Mon, 28 Jun 2010 14:15:54 +0200
> > > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > > CommitDate: Tue, 29 Jun 2010 12:12:59 +0200
> > > 
> > > x86: Always use irq stacks
> >
> > [...]
> > 
> > Checking out 7974891db2 and building+booting a kernel with this config 
> > causes shows the crash.
> > 
> > Checking out 7974891db2~1 and building+booting a kernel with this config 
> > gives a working system.
> > 
> > Note that tip:x86/irq has these commits currently:
> > 
> >  1813a68: x86: Move alloc_desk_mask variables inside ifdef
> >  2589737: x86-32: Align IRQ stacks properly
> >  dcfa726: x86: Remove CONFIG_4KSTACKS
> >  7974891: x86: Always use irq stacks
> 
> Hello Ingo, Christoph, ...
> 
> There is still a problem with the alignment of the irq stacks. Maybe it's only
> theoretical, but I think the attached patch is necessary. (Attached because
> I'm sending it via a web interface.)
> 
> Please test and apply :).

This apparently solved the crash, thanks a lot Alexander!

	Ingo
