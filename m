Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab1E2S4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:56:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030Ab1E2S4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:56:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110529060702.GA7112@vigoh>
References: <20110529060702.GA7112@vigoh>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 May 2011 11:55:19 -0700
Message-ID: <BANLkTimKjb5hNUJv1EsRuHdWZ1Wv5mrswg@mail.gmail.com>
Subject: Re: [GIT PULL] Fix common misspellings
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 11:07 PM, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
>
> Please pull the following fixes for common misspellings. This patch is shorter
> than the other time, but larger than I expected, partially because there were
> some new entries in the dictionary.

This pull request is probably perfectly fine, but since I'll be
travelling with a rather weak laptop next week, and there were some
complaints about the cross-subsystem merge problems that the big(ger)
spelling fixes caused last time around, I'm afraid that I ended up
feeling that it's easier for me to ignore this pull request at this
time.

When I'm back from traveling,. and if this release window turns out to
be quiet and problem free, I might decide that I'll pull some trivial
spelling fixes during a later -rc phase. On the other hand, I might
also go for being very strict about the -rc's too, so no promises.

Because I might just try to make 2.6.40 (or whatever I'll call it -
I'll throw some mental dice before cutting the -rc1 later today) be
one of those nice "strict and stable and as little excitement as
possible" releases. The merge window itself has been pretty calm so
far, I think, which is a good thing.

                        Linus
