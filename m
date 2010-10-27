Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab0J0JJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:09:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39522 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0J0JJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:09:18 -0400
Date: Wed, 27 Oct 2010 11:09:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, n-horiguchi@ah.jp.nec.com, x86@kernel.org
Subject: Re: [GIT PULL] Please pull hwpoison updates for 2.6.37
Message-ID: <20101027090903.GA16957@elte.hu>
References: <20101026100923.GA5118@basil.fritz.box>
 <20101027074254.GA809@elte.hu>
 <20101027075846.GA2472@basil.fritz.box>
 <20101027081853.GA20196@elte.hu>
 <20101027090128.GC2472@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027090128.GC2472@basil.fritz.box>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > You are welcome! How about the cleanliness feedback that i gave?
> > (the stuff in parentheses)
> 
> Could move the ifdef into mm.h for the flags and let the optimizer
> eliminate the code. I can do that in a followup patch.

Yeah. If it does not work out due to architectural differences then
do not push it too hard (the code is small enough) - we only want to
factor this out if it makes things cleaner.

Thanks,

	Ingo
