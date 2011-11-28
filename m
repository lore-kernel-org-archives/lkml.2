Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1K1FII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:08:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45731 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1K1FIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111128034658.GA3503@Brahman>
References: <bug-41132-5003@https.bugzilla.kernel.org/>
	<201108160554.p7G5soeq002083@demeter2.kernel.org>
	<CAOtrxKP-0TfJa8dS8_uW195WO13YCy-UyaZfweYD4Tv_1gAmKQ@mail.gmail.com>
	<CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
	<20111128034658.GA3503@Brahman>
Date: Mon, 28 Nov 2011 03:08:03 -0200
X-Google-Sender-Auth: i2K6YVwLs4V5GQk__1tu19wBVhI
Message-ID: <CAOtrxKMRBfY=68A1+=F5+WGwEwkvLY7DumsGTevUeY_Cs7feLQ@mail.gmail.com>
Subject: Re: [Bug 41132] [BISECTED][REGRESSION] Regression with the IRQ
 subsystem introduced in 2.6.39 (and present in the 3.x version)
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Edward Donovan <edward.donovan@numble.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        drivers_pci@kernel-bugs.osdl.org,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus, and Edward.

First of all, thank you very much for being so gentle to take the time
to read my report. For some months now I tried to reach some people in
this CC list, but got no response.

On Mon, Nov 28, 2011 at 01:46, Edward Donovan <edward.donovan@numble.net> wrote:
> On Sun, Nov 27, 2011 at 12:22:54PM -0800, Linus Torvalds wrote:
>> I haven't seen any response to this one, and while clearly commit
>> fa27271bc8d2 ("genirq: Fixup poll handling") was *supposed* to be a
>> no-op, it isn't.
(...)
>
> I experienced the regression in fa2727, too, and recently submitted a
> patch; I believe Thomas has it queued for review.  I'll repost here.

Thanks. I just compiled Linus's tree with your patch and I'm typing
this message running with such kernel. From my very basic testing, it
seems that everything is working as well as it did in 2.6.38.

> Happy to revise, or test suggestions against my bad-irq boxes.

I have some other bad-irq boxes that I can test on [*], but, so far,
you can add a "Tested-by: Rogério Brito <rbrito@ime.usp.br>" to your
patch (and, if you like, a Reported-by too).


Thanks a lot,
Rogério Brito.

[*] For instance, my mother's laptop, as reported on
https://lkml.org/lkml/2011/8/19/428

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
