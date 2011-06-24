Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1FXV2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:28:37 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:54923 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1FXV2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimKjb5hNUJv1EsRuHdWZ1Wv5mrswg@mail.gmail.com>
References: <20110529060702.GA7112@vigoh> <BANLkTimKjb5hNUJv1EsRuHdWZ1Wv5mrswg@mail.gmail.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 24 Jun 2011 18:28:16 -0300
Message-ID: <BANLkTi=HMx2CFpeoc4t7m8u4wOCxzu4apQ@mail.gmail.com>
Subject: Re: [GIT PULL] Fix common misspellings
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 3:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, May 28, 2011 at 11:07 PM, Lucas De Marchi
> <lucas.demarchi@profusion.mobi> wrote:
>>
>> Please pull the following fixes for common misspellings. This patch is shorter
>> than the other time, but larger than I expected, partially because there were
>> some new entries in the dictionary.
>
> This pull request is probably perfectly fine, but since I'll be
> travelling with a rather weak laptop next week, and there were some
> complaints about the cross-subsystem merge problems that the big(ger)
> spelling fixes caused last time around, I'm afraid that I ended up
> feeling that it's easier for me to ignore this pull request at this
> time.
>
> When I'm back from traveling,. and if this release window turns out to
> be quiet and problem free, I might decide that I'll pull some trivial
> spelling fixes during a later -rc phase. On the other hand, I might
> also go for being very strict about the -rc's too, so no promises.

So I think the best thing is to wait for 3.1. Otherwise there will be
several conflicts in linux-next.

I'll prepare another patch (this doesn't apply cleanly anymore and
there are other fixes) and re-send when it's time.


Thanks

Lucas De Marchi
