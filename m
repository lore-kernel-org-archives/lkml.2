Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235Ab0JZRxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:53:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab0JZRxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:53:09 -0400
Date: Tue, 26 Oct 2010 19:52:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Charles Edward Lever <Chuck.Lever@oracle.com>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for October 6
Message-ID: <20101026175256.GA12141@elte.hu>
References: <20101006163632.c1943a38.sfr@canb.auug.org.au>
 <AANLkTimb2NxXcfj-o=F18S1u2rn-o851F+1sgQ_2uOVQ@mail.gmail.com>
 <20101026080822.GA10520@elte.hu>
 <1288096333.3123.9.camel@heimdal.trondhjem.org>
 <20101026124113.GA10872@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026124113.GA10872@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> 
> > Anyhow, does the following fix the bug?
> 
> Thanks, trying it.

It has done the trick.

Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
