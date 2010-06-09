Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0FILGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:06:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43359 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0FILGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:06:16 -0400
Message-ID: <4C0F7533.4070502@monstr.eu>
Date: Wed, 09 Jun 2010 13:04:19 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3 v2
References: <4C0D3853.60000@petalogix.com> <alpine.LFD.2.00.1006081313080.4506@i5.linux-foundation.org> <AANLkTikeD21EtwtASzj8RksDqZyEof_kmUTnNr2HwwU2@mail.gmail.com> <alpine.LFD.2.00.1006081720060.4506@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006081720060.4506@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 8 Jun 2010, Geert Uytterhoeven wrote:
>> Seems like you will have written more angry emails than there will be
>> new commits in 2.6.35-rc3 ;-)
> 
> Well, partly in order to be fair. I did consider letting architectures 
> like microblaze just off the hook entirely - it's not like it will affect 
> a lot of people. But at the same time, I don't want to be in the situation 
> that some people get to send me patches just because I don't happen to 
> think that their changes will matter to most others.
> 
> And at this stage, I'd rather be too strict than too lenient. If -rc3 has 
> no new regressions, and fixes the ones that hit people worst, I'll be very 
> happy. I can be more open to patches after I get back, if it turns out 
> that I was _too_ strict for -rc3.
> 
> As to the number of "no, I won't take it" emails, I suspect a large part 
> of that is simply because most developers (understandably) do not read 
> lkml, stauing mostly on the development lists that are more specific to 
> their particular area. As a result, there's no real way to reliably reach 
> people, and I end up sending basically the same message several times.
> 
> Which obviously tends to also then make the messages more cross ;)

First of all let me apologize for this situation. There is no excuse
that I sent new features in requests after rc.

I've changed my workflow and I will send new pull request with the 
strict regression fixes only. There will be only two patches which I 
would like to add to your tree.

Thanks and sorry for hassle,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
