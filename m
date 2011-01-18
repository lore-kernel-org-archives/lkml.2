Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1ARWJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:09:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1ARWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:09:30 -0500
Date: Tue, 18 Jan 2011 23:09:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, arjan@linux.intel.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, linux@merz-ka.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Clear irqstack thread_info
Message-ID: <20110118220914.GB15672@elte.hu>
References: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
 <tip-7b698ea377e10b074ceef0d79218e6622d618421@git.kernel.org>
 <1295387110.19231.36.camel@jaguar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295387110.19231.36.camel@jaguar>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On Tue, 2011-01-18 at 19:03 +0000, tip-bot for Brian Gerst wrote:
> > Commit-ID:  7b698ea377e10b074ceef0d79218e6622d618421
> > Gitweb:     http://git.kernel.org/tip/7b698ea377e10b074ceef0d79218e6622d618421
> > Author:     Brian Gerst <brgerst@gmail.com>
> > AuthorDate: Mon, 17 Jan 2011 07:32:10 -0500
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 18 Jan 2011 14:58:37 +0100
> > 
> > x86: Clear irqstack thread_info
> > 
> > Mathias Merz reported that v2.6.37 failed to boot on his
> > system.
> > 
> > Make sure that the thread_info part of the irqstack is
> > initialized to zeroes.
> > 
> > Reported-and-Tested-by: Matthias Merz <linux@merz-ka.de>
> > Signed-off-by: Brian Gerst <brgerst@gmail.com>
> > Acked-by: Pekka Enberg <penberg@kernel.org>
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > LKML-Reference: <AANLkTimyKXfJ1x8tgwrr1hYnNLrPfgE1NTe4z7L6tUDm@mail.gmail.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> This needs to be tagged for -stable as well.

Indeed, i meant to do that but forgot. I've forwarded it to the -stable guys now.

Thanks,

	Ingo
