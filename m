Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2DQKH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:07:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48164 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2DQKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:07:54 -0400
Date: Tue, 17 Apr 2012 12:07:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: revert --strict test for net/ and
 drivers/net block comment style
Message-ID: <20120417100748.GA17894@gmail.com>
References: <20120416091719.GA4113@gmail.com>
 <4F8C76A0.2050601@xenotime.net>
 <1334604911.2726.2.camel@joe2Laptop>
 <20120416202813.GB4678@gmail.com>
 <CA+55aFz6FFQAyx5E10CpwC1H+pOYqqLwQnkgUBYDp_zjH4t2pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz6FFQAyx5E10CpwC1H+pOYqqLwQnkgUBYDp_zjH4t2pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Apr 16, 2012 at 1:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Joe Perches <joe@perches.com> wrote:
> >
> >> Revert the --strict test for the old preferred block
> >> comment style in drivers/net and net/
> >
> > Emphatic NAK.
> 
> Ingo, I don't think you understood. That test reverts the thing you
> wanted reverted wrt the block comments.

Yeah, I was confused: I judged it by the title and description 
and assumed it was only doing it for drivers/net/ and net/.

But in reality it just does a wholesale revert of this check 
with no net/ and drivers/net/ specificity to it, so it's 
perfectly fine to me:

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
