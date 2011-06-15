Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1FOHhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:37:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1FOHhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:37:36 -0400
Date: Wed, 15 Jun 2011 09:37:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4 of 6] x86, UV: correct reset_with_ipi()
Message-ID: <20110615073726.GB3538@elte.hu>
References: <E1QWchM-0004NL-M6@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QWchM-0004NL-M6@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> Fix reset_with_ipi() to look up a cpu for a blade based on the
> distribution map being indexed by the potentially sparsely numbered pnode
> (relative to the partition base pnode). (It had been doing it based on
> 0-based, consecutive blade id.)

That's one fix.

> Rename 'hubmask' to 'pnmask' for clarity.

That's another one.

> And remove the stack-resident cpumask_t from reset_with_ipi() by allocating
> one per uvhub.

That's a third one.

Why isnt this done in three separate patches?

	Ingo
