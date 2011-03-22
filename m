Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1CVMeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:34:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab1CVMeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:34:10 -0400
Date: Tue, 22 Mar 2011 13:33:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>, jason.wessel@windriver.com
Subject: Re: [PATCH 2/4] perf: fix common misspellings
Message-ID: <20110322123357.GA14352@elte.hu>
References: <1300455630-21577-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1300455630-21577-2-git-send-email-lucas.demarchi@profusion.mobi>
 <20110322103735.GD4448@elte.hu>
 <AANLkTik7wKdf_yCukg7RAAE5PWXw5YkAG=hSBuSn1wn9@mail.gmail.com>
 <20110322114405.GE4448@elte.hu>
 <AANLkTinqC33LE7V-2VzEJ_xnZdmokg8P7px1KP8m2DFf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinqC33LE7V-2VzEJ_xnZdmokg8P7px1KP8m2DFf@mail.gmail.com>
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


* Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

>  2530 files changed, 4988 insertions(+), 4988 deletions(-)

Hm, i definitely think we do not want hundreds of commits per cycle to have a 
'split up' patchset for these spelling fixes.

A once per cycle patch to fix such things would be the most optimal model IMHO 
- and hopefully with time the patches will be getting (much) smaller :-)

Anyway, it's all up to Linus whether he'll take a big patch.

Thanks,

	Ingo
