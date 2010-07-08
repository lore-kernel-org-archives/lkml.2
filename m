Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab0GHUnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:43:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab0GHUnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:43:04 -0400
Date: Thu, 8 Jul 2010 22:42:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100708204251.GA13569@elte.hu>
References: <20100628121554.GA6605@lst.de>
 <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
 <20100630074434.GA25509@elte.hu>
 <20100630075212.GA24658@lst.de>
 <20100630075818.GB25509@elte.hu>
 <20100630080453.GA14371@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630080453.GA14371@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4523]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > > Reverting 7974891db2 and dcfa72628 makes the crash go away.
> > > > 
> > > > Full crashlog and config attached.
> > > 
> > > What kernel is the .config for?  Trying to compile your x86/irq branch
> > > with it asks lots of questions during make oldconfig for it.
> > 
> > Just accept the defaults for it.
> 
> I can see the crash with vanilla x86/irq as well, with the config i sent.

Ping?

	Ingo
