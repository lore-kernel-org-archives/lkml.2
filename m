Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1EDLOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:14:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab1EDLOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:14:04 -0400
Date: Wed, 4 May 2011 13:13:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
Message-ID: <20110504111355.GC5914@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu>
 <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
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


* Nikhil Rao <ncrao@google.com> wrote:

> Also, out of curiosity, what's an acceptable tolerance level for a 
> performance hit on 32-bit?

It's a cost/benefit analysis and for 32-bit systems the benefits seem to be 
rather small, right?

Can we make the increase in resolution dependent on max CPU count or such and 
use cheaper divides on 32-bit in that case, while still keeping the code clean? 

We'd expect only relatively large and new (and 64-bit) systems to run into 
resolution problems, right?

Thanks,

	Ingo
