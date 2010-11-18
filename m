Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0KRIOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:14:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0KRIOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:14:17 -0500
Date: Thu, 18 Nov 2010 09:14:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] x86: only call smp_processor_id in non-preempt cases
Message-ID: <20101118081407.GB23481@elte.hu>
References: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289573455-3410-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0018]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> There are some paths that walk the die_chain with preemption on.

What are those codepaths? At minimum it's worth documenting them.

Thanks,

	Ingo
