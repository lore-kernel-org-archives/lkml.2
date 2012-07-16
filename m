Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2GPQ2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:28:43 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55745 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2GPQ2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:28:42 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.5-rc7
Date: Mon, 16 Jul 2012 18:28:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc6-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>
References: <CA+55aFxLmxGaMUbEVSaG-Og=G1rf1TBrswuVwfwWUqbCPuAVrA@mail.gmail.com> (sfid-20120715_130824_258581_628B0AA0)
In-Reply-To: <CA+55aFxLmxGaMUbEVSaG-Og=G1rf1TBrswuVwfwWUqbCPuAVrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207161828.40586.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 15. Juli 2012 schrieb Linus Torvalds:
> Hey guys,

Hi Linus,

> remember how things have been stabilizing and slowing down,
> and all the kernel developers were off on summer vacation?
> 
> Yeah, we need to talk about that. Because I last week I thought that
> making an -rc7 was not necessarily realy required, except perhaps
> mainly to check the late printk changes. But then today and yesterday,
> I got a ton of small pull requests, and now I find myself releasing an
> -rc7 that is actually bigger than rc6 was.
> 
> Not cool, guys. Not cool.
> 
> Now, admittedly, most of this is pretty small. The loadavg calculation
> fix patch is pretty big, but quite a lot of that is added comments
> (*big* added comments). . But there's Andrew's patch-bomb, there's
> media fixes, there's random SOC fixes, powerpc fixes, USB, sound, you
> name it.
> 
> Ok, so it's still not *huge*, but it's bigger than -rc6 was. I had
> hoped for less.

Regresses badly on resume from in-kernel hibernation. I.e. hangs with some 
red graphics artifacts on the tty. The same artifacts appear for a short 
time with rc6 + some commits as well, but there then X.org is available 
again.

2437fccfbfc83bcb868ccc7fdfe2b5310bf07835 – thats rc6 + some commits – 
works, while exactly rc7 does not.

No bisection tried so far. Maybe tomorrow. It shouldn´t be that many 
attempts and kernel compiles are fast on the ThinkPad T520 with Intel i5 
Sandybridge + integrated graphics – no NVidia – + Intel SSD 320 where this 
happens. No other machines tested so far.

Kernel configuration available if desired.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
