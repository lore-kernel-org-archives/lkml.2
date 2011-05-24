Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1EXMPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:15:17 -0400
Received: from seven.medozas.de ([188.40.89.202]:42421 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab1EXMPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:15:14 -0400
Date: Tue, 24 May 2011 14:15:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm <linux-mm"@kvack.medozas.de
Subject: Re: (Short?) merge window reminder
In-Reply-To: <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com>
 <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2011-05-24 01:33, Linus Torvalds wrote:

>Another advantage of switching numbering models (ie 3.0 instead of
>2.8.x) would be that it would also make the "odd numbers are also
>numbers" transition much more natural.
>
>Because of our historical even/odd model, I wouldn't do a 2.7.x -
>there's just too much history of 2.1, 2.3, 2.5 being development
>trees.

.oO(Though once 2.{7 or more, odd} trickle into the distros, it would 
become pretty much apparent that they are not devel.)

>And then in another few years (probably before getting close to 3.40,
>so I'm not going to make a big deal of 3 = "third decade"), I'd just
>do 4.0 etc.

While 2.6 has certainly worn out, already thinking of a 4.0 is highly 
reminiscient of the version number arms race Firefox and ChromeBrowser 
are doing currently.

>Because all our releases are supposed to be stable releases these
>days, and if we get rid of one level of numbering, I feel perfectly
>fine with getting rid of the even/odd history too.

If I remember past-time discussions right, ELF was the contributing 
factor to bump the major number to 2.0 back then; ever since 2.0, no 
similarly breakthrough-ing event has occurred.
