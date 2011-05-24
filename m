Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1EXRgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:36:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab1EXRgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:36:48 -0400
Message-ID: <4DDBEC91.8020004@zytor.com>
Date: Tue, 24 May 2011 10:36:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jacek Luczak <difrost.kernel@gmail.com>,
        Jan Engelhardt <jengelh@medozas.de>, linux-arch@vger.kernel.org,
        linux-mm <linux-mm@kvack.medozas.de>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: (Short?) merge window reminder
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>	<20110523192056.GC23629@elte.hu>	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>	<20110523231721.GM10009@thunk.org>	<4DDAEC68.30803@zytor.com>	<BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>	<alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>	<BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com>	<alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr>	<BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com>	<20110524154348.27ba649d@lxorguk.ukuu.org.uk> <BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com>
In-Reply-To: <BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 08:07 AM, jonsmirl@gmail.com wrote:
> On Tue, May 24, 2011 at 10:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Can we drop most of MCA, EISA and ISA bus if we are going to have a big
>> version change ? A driver spring clean is much overdue and it's all in
>> git in case someone wishes to sneak out at midnight and bring some crawly
>> horror back from the dead.
> 
> 2.8 could mark the beginning of the great cleanup
>   --- work out the details of what needs to be cleaned and set a goal
>   --- remove old buses/driver, switch to device tree, graphics, 32/64
> merges, etc
> 3.0 would mark its completion
> 

I think this whole discussion misses the essence of the new development
model, which is that we no longer do these kinds of feature-based major
milestones.  If we want to to deprecate lots of drivers (which I
personally would advocate against -- I have built systems specifically
to run a real floppy drive since the Linux floppy driver is amazingly
flexible and can read/write a lot of formats that nothing else can,
including USB floppies) then we should do that in the normal course of
action, incrementally, and listed in feature-removal-schedule.txt, not
all at once due to some arbitrary milestone.

We have found it works better this way.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

