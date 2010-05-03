Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0ECGyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:54:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60209 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0ECGyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:54:46 -0400
Date: Mon, 3 May 2010 08:54:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] perf inject + say no to __KERNEL__ only stuff
Message-ID: <20100503065416.GD15241@elte.hu>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
 <20100503062407.GB15241@elte.hu>
 <4BDE6D5A.6060407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDE6D5A.6060407@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/02/2010 11:24 PM, Ingo Molnar wrote:
> > 
> > Pulled, thanks a lot!
> > 
> 
> With this, core/hweight should work properly, I hope.

Ok, i merged that too - will let you know about any trouble.

Thanks,

	Ingo
