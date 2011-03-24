Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1CXQv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:51:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1CXQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:51:56 -0400
Date: Thu, 24 Mar 2011 17:51:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
Message-ID: <20110324165142.GB2414@elte.hu>
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
 <20110324084819.GH30812@elte.hu>
 <4D8B6569.2030001@gmail.com>
 <20110324163332.GA2414@elte.hu>
 <4D8B7570.40101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B7570.40101@gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Unflagged overflows never have been catched due to missed read of a register which
> is to signalize about it, and as result unknown nmi may happen leading to
> "Dazen and confused" message. That is what supposed to be in changelog?

Exactly, the 'Dazed and confused' message is *all* that the user cares about so 
it must feature prominently in the changelog.

If a P4 user searches lkml he wants to know which fixed address 
dazed-and-confused messages. He will know nothing about 'unflagged overflows' 
or other internals ...

All the other details about how the patch does the fix is secondary to what 
users experience when they hit this bug.

Thanks,

	Ingo
