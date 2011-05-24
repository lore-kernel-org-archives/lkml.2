Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab1EXVFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:05:33 -0400
Received: from seven.medozas.de ([188.40.89.202]:41549 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab1EXVFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:05:32 -0400
Date: Tue, 24 May 2011 23:05:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: eschvoca <eschvoca@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jacek Luczak <difrost.kernel@gmail.com>, linux-arch@vger.kernel.org,
        linux-mm <linux-mm@kvack.medozas.de>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: (Short?) merge window reminder
In-Reply-To: <BANLkTi=Rky8zGrJ7TSF0MumzQWjpsD7Lcw@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1105242207150.2318@frira.zrqbmnf.qr>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com> <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
 <alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr> <BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com> <alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr> <BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com> <20110524154348.27ba649d@lxorguk.ukuu.org.uk>
 <BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com> <4DDBEC91.8020004@zytor.com> <BANLkTimGGukCD_eLfCTXWjbiz=7ucEwj7Q@mail.gmail.com> <BANLkTi=Rky8zGrJ7TSF0MumzQWjpsD7Lcw@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2011-05-24 20:48, eschvoca wrote:
>On Tue, May 24, 2011 at 1:41 PM, Linus Torvalds wrote:
>>
>> It's not about features. It hasn't been about features for forever.
>
>Using the date also clearly communicates it is not about features.

On the contrary: Whenever a 2.6.x release was set out the door, there
was at least one new feature in the cycle. Given the endless manpower
that seems to trail Linux, that seems unlikely to change in the near
term.

On "It is not about features" - it is not /just/ about features - it
is also about fixes, which are equally important, and they also
warrant a version bump of some sort on their own. Pointing out the
obvious, the stable serieses.

"Fleeing" to date-based version numbering seems like an excuse
for making way for releases without any change whatsoever.
(IOW, if there were features/fixes, a non-date based scheme of
incremental numbers could indicate them already.)


>Me, a nobody end user, would prefer a version number that corresponded
>to the date.  Something like:
>
>%y.%m.<stable patch>
>%Y.%m.<stable patch>

Except that LINUX_KERNEL_VERSION has only 8 bits for each,
so 2011 is out of range, which would need to kept in mind.
And a 2-digit spec.. nah that does not feel very 100-year
proof. (Just look at struct tm.tm_year for the mess 2-digits
made technically.)

>Then users would know the significance of the number and when a vendor
>says they support Linux 11.09 the user will immediately know if they
>are up to date.

An added issue with that would be that numbers would not increase in
same-sized steps anymore and leave gaps. (There would probably be no
11.06 between 11.05 aka 2.6.39 and 11.07-or-so aka 2.6.40)


My 2円.
