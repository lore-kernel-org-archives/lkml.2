Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1LSQaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:30:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1LSQaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:30:01 -0500
Date: Mon, 19 Dec 2011 17:28:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20111219162808.GB10017@elte.hu>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
 <20111219112326.GA15090@elte.hu>
 <87k45sbxa6.fsf@abhimanyu.in.ibm.com>
 <8762hcbsrv.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8762hcbsrv.fsf@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:

> On Mon, 19 Dec 2011 17:15:05 +0530, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> > > 
> > > What's behind this huge speedup? Does ebizzy use user-space 
> > > spinlocks perhaps? Could we do something on the user-space side 
> > > to get a similar speedup?
> > > 
> > Some more oprofile data here for the above ebizzy-2VM run:
> > 
> That is readprofile data, kernel booted with profile=2

Btw., you could try this newfangled tools/perf/ thing to profile 
the kernel ;-)

Thanks,

	Ingo
