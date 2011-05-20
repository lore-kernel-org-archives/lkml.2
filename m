Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab1ETAUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:20:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65139 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab1ETAUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CMNM5P9M9bYyHZ9egLsolh3X/RYh/dzs9IIBt04vy3NKHDVGrhCB6FxuSCkMtfrCPy
         wTePVTjcOn7OZC4vVDufIeFLteaSxVtYOl8tVJBfdfsHlpcLWke9mFx4cxWfVEtnpzx4
         EiR2qt8nou6vwkJULlVj1DCkNnzYpFcpHAVrU=
MIME-Version: 1.0
In-Reply-To: <20110519145147.GA14658@localhost>
References: <BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
	<20110514165346.GV6008@one.firstfloor.org>
	<BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
	<20110514174333.GW6008@one.firstfloor.org>
	<BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
	<20110515152747.GA25905@localhost>
	<BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
	<20110517060001.GC24069@localhost>
	<BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com>
	<BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com>
	<20110519145147.GA14658@localhost>
Date: Fri, 20 May 2011 09:20:07 +0900
Message-ID: <BANLkTi=cPRffdaPO9tOfgpLe7W_W3V71tg@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 11:51 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > I had 6GB swap available, so there shouldn't have
>> > been any OOM.
>>
>> Yes. It's strange but we have seen such case several times, AFAIR.
>
> I noticed that the test script mounted a "ramfs" not "tmpfs", hence
> the 1.4G pages won't be swapped?

Right. ramfs pages can not be swapped out.
But in log, anon 200M in DMA32 doesn't include unevictable 1.4GB.
So we can swap out 200M, still.

>
> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim
