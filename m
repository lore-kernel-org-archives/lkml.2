Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1DRNEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:04:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48135 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1DRNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:04:45 -0400
Date: Mon, 18 Apr 2011 15:04:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: remove hrtick_enabled()
Message-ID: <20110418130441.GA29530@elte.hu>
References: <BANLkTi=kEvVCwxd=g65jBGTzmZD_KtT92w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=kEvVCwxd=g65jBGTzmZD_KtT92w@mail.gmail.com>
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


* Hillf Danton <dhillf@gmail.com> wrote:

> The function, hrtick_enabled(), could be removed, since it is not used
> anywhere, though defined.

Well, what about kernel/sched_fair.c?

Thanks,

	Ingo
