Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0H3GYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 02:24:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0H3GYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 02:24:10 -0400
Date: Mon, 30 Aug 2010 08:24:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] memblock: Rename memblock_region to
 memblock_type and memblock_property to memblock_region
Message-ID: <20100830062402.GA19309@elte.hu>
References: <tip-e3239ff92a17976ac5d26fa0fe40ef3a9daf2523@git.kernel.org>
 <1282958776.1922.58.camel@pasglop>
 <8eebfe0a-80fe-4cbe-ab13-305c81555252@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eebfe0a-80fe-4cbe-ab13-305c81555252@email.android.com>
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

> "Benjamin Herrenschmidt" <benh@kernel.crashing.org> wrote:
> 
> >On Sat, 2010-08-28 at 00:37 +0000, tip-bot for Benjamin Herrenschmidt
> >wrote:
> >> Commit-ID:  e3239ff92a17976ac5d26fa0fe40ef3a9daf2523
> >> Gitweb:     http://git.kernel.org/tip/e3239ff92a17976ac5d26fa0fe40ef3a9daf2523
> >> Author:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >> AuthorDate: Wed, 4 Aug 2010 14:06:41 +1000
> >> Committer:  Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >> CommitDate: Wed, 4 Aug 2010 14:21:49 +1000
> >> 
> >> memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region
> >
> >He, I was just about to rebase them :-)
> >
> >Do you still need me to do that ?
>
> I don't think so, but Ingo might need you to if it doesn't merge cleanly.

No need to, i resolved the conflicts.

Thanks,

	Ingo
