Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1CVQjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:39:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800Ab1CVQjm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:39:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110322123357.GA14352@elte.hu>
References: <1300455630-21577-1-git-send-email-lucas.demarchi@profusion.mobi>
 <1300455630-21577-2-git-send-email-lucas.demarchi@profusion.mobi>
 <20110322103735.GD4448@elte.hu> <AANLkTik7wKdf_yCukg7RAAE5PWXw5YkAG=hSBuSn1wn9@mail.gmail.com>
 <20110322114405.GE4448@elte.hu> <AANLkTinqC33LE7V-2VzEJ_xnZdmokg8P7px1KP8m2DFf@mail.gmail.com>
 <20110322123357.GA14352@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 09:31:14 -0700
Message-ID: <AANLkTimQ2tHwbkbd5qRgtpuzm25Hf0PEzUVQp=LKLOPu@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf: fix common misspellings
To: Ingo Molnar <mingo@elte.hu>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>, jason.wessel@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 5:33 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:
>
>>  2530 files changed, 4988 insertions(+), 4988 deletions(-)
>
> Hm, i definitely think we do not want hundreds of commits per cycle to have a
> 'split up' patchset for these spelling fixes.
>
> A once per cycle patch to fix such things would be the most optimal model IMHO
> - and hopefully with time the patches will be getting (much) smaller :-)
>
> Anyway, it's all up to Linus whether he'll take a big patch.

I can take a big patch, but not during the merge window when there are
outstanding pull reqeuests etc. But possibly soon after -rc1, if it
gets some review and I feel comfortable that the patch is clearly only
spelling in comments (or whatever the exact rules are for codespell)

                                Linus
