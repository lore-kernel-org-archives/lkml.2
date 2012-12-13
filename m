Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2LMVw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 16:52:56 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:38347 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab2LMVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 16:52:55 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <CA+55aFwzUgxQAze=mYbEx8b61V542tzm06Df=mR1BtYVbJy0mg@mail.gmail.com>
References: <20121212.151116.143443755590581447.davem@davemloft.net>
	<CA+55aFwzUgxQAze=mYbEx8b61V542tzm06Df=mR1BtYVbJy0mg@mail.gmail.com>
Date: Thu, 13 Dec 2012 22:52:54 +0100
Message-ID: <CAOesGMi-=4sFvbe1DGThQCe8Rd0Za1oSDvTdbbNm3iBX0AZGaQ@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 3:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 12, 2012 at 12:11 PM, David Miller <davem@davemloft.net> wrote:
>>
>> There is one merge conflict to resolve in net/sched/cls_cgroup.c,
>> one commit changes the name of some members to "css_*" (this came
>> from Tejun's tree) and another commit adds an "attach" method.
>
> There's more than that. The ARM board mess is apparently now affecting
> the networking merges too.
>
> I fixed it up. Hopefully correctly.

Yes, it looks correct. Sorry about missing that earlier, sfr had
spotted it when it showed up in linux-next but I lost track of it.

We probably need to restructure/resort the device tree files to avoid
add/add conflicts when people just append to them all the time. I
really hope things will start to settle down churn-wise soon, as
conversions and DT enablement starts to be more complete.

(I also think we need to improve the way we handle our topics some, we
have a bit too much internal conflicts between topics in arm-soc
still, but that's a separate subject).


-Olof
