Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637Ab0JIX0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 19:26:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757324Ab0JIX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 19:26:10 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Oct 2010 16:24:59 -0700
Message-ID: <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken on
 SGI UV
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 2:34 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> Do we track people dong this at all? I wonder how many patches in
> linux-next have cc: stable in them but haven't been submitted to
> Linus,

The other side of that coin is to wonder how many patches get marked
as "stable" when they definitely shouldn't be.

I know that's a non-empty set. Too many developers think that the
thing they fix is so important that it needs to be backported. And it
doesn't help that Greg is sometimes over-eager to take things without
them being even in my tree long enough to get much testing.

Quite frankly, if somebody has something in "next" (and really meant
for the _next_ merge window, not the current one) that is marked for
stable, I think that shows uncommonly bad taste. And that, in turn,
means that the "stable" tag is also very debatable. It clearly cannot
be important enough to really be for stable if it's not even being
aggressively pushed into the current -rc.

                 Linus
