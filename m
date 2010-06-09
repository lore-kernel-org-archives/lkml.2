Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0FIA3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 20:29:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886Ab0FIA3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 20:29:23 -0400
Date: Tue, 8 Jun 2010 17:29:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3 v2
In-Reply-To: <AANLkTikeD21EtwtASzj8RksDqZyEof_kmUTnNr2HwwU2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006081720060.4506@i5.linux-foundation.org>
References: <4C0D3853.60000@petalogix.com> <alpine.LFD.2.00.1006081313080.4506@i5.linux-foundation.org> <AANLkTikeD21EtwtASzj8RksDqZyEof_kmUTnNr2HwwU2@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Geert Uytterhoeven wrote:
> 
> Seems like you will have written more angry emails than there will be
> new commits in 2.6.35-rc3 ;-)

Well, partly in order to be fair. I did consider letting architectures 
like microblaze just off the hook entirely - it's not like it will affect 
a lot of people. But at the same time, I don't want to be in the situation 
that some people get to send me patches just because I don't happen to 
think that their changes will matter to most others.

And at this stage, I'd rather be too strict than too lenient. If -rc3 has 
no new regressions, and fixes the ones that hit people worst, I'll be very 
happy. I can be more open to patches after I get back, if it turns out 
that I was _too_ strict for -rc3.

As to the number of "no, I won't take it" emails, I suspect a large part 
of that is simply because most developers (understandably) do not read 
lkml, stauing mostly on the development lists that are more specific to 
their particular area. As a result, there's no real way to reliably reach 
people, and I end up sending basically the same message several times.

Which obviously tends to also then make the messages more cross ;)

			Linus

