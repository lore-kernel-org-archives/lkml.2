Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab1FIJTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:19:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1FIJTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:19:32 -0400
Date: Thu, 9 Jun 2011 11:19:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf update
Message-ID: <20110609091924.GA8188@elte.hu>
References: <1307458585-24078-1-git-send-email-fweisbec@gmail.com>
 <1307610813.3941.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307610813.3941.23.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-06-07 at 16:56 +0200, Frederic Weisbecker wrote:
> 
> > Frederic Weisbecker (1):
> >       perf: Split up buffer handling from core code
> > 
> > 
> >  kernel/events/Makefile   |    2 +-
> >  kernel/events/buffer.c   |  400 ++++++++++++++++++++++++++++++++++++++++
> >  kernel/events/core.c     |  458 ++--------------------------------------------
> >  kernel/events/internal.h |   70 +++++++
> >  4 files changed, 487 insertions(+), 443 deletions(-)
> 
> Looks about right.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

thanks, i'll pull it it and test it.

	Ingo
